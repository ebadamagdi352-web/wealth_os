import 'package:equatable/equatable.dart';

/// What kind of account this is.
///
/// [displayLabel] is **not localized**. `AppRoute.titleKey` has the same problem
/// and for the same reason: the ARB files contain four keys and none of them are
/// these. Localization has been out of scope for six consecutive tasks. When the
/// keys exist, this field becomes `labelKey` and the label is resolved against
/// the active locale.
enum AccountType {
  checking(iconKey: 'checking', displayLabel: 'Checking'),
  cash(iconKey: 'cash', displayLabel: 'Cash'),
  savings(iconKey: 'savings', displayLabel: 'Savings'),
  creditCard(iconKey: 'credit_card', displayLabel: 'Credit Card');

  const AccountType({required this.iconKey, required this.displayLabel});

  /// Stable identifier for the icon. Resolved to an `IconData` by the widgets.
  ///
  /// A string, not an `IconData`, so this file stays pure Dart and can be
  /// unit-tested without a widget binding.
  final String iconKey;

  /// Human-readable label. Not localized — see the class doc.
  final String displayLabel;
}

/// An account, as the accounts screen needs to see it.
///
/// ## Why this is `sealed`, and why it is the most important decision in the task
///
/// Three of the four accounts hold money. The fourth is a credit card, which
/// holds **debt** — it has a limit and a used amount, and it does not have a
/// balance in the same sense at all.
///
/// The tempting model is one class with everything on it:
///
/// ```dart
/// class Account {
///   final double? balance;      // null for credit cards
///   final double? creditLimit;  // null for everything else
///   final double? usedAmount;   // null for everything else
/// }
/// ```
///
/// That model makes eight states representable and only two of them legal. It
/// permits a chequing account with a credit limit, a credit card with a balance
/// and no limit, and — worst — an account with *nothing* set, which renders as a
/// blank card that nobody can explain. Every call site then defends itself with
/// `!` and null checks, and the compiler helps with none of it.
///
/// Sealed, the illegal states cannot be constructed. A `switch` over an account
/// is checked for exhaustiveness, so adding a fifth account kind — a loan, a
/// brokerage — will not compile until every screen has decided what to do with
/// it. That is the entire value: **the compiler finds the screens you forgot.**
sealed class AccountSummary extends Equatable {
  const AccountSummary({
    required this.id,
    required this.name,
    required this.type,
    required this.currencyCode,
  });

  /// Stable identifier. Generated client-side so an account has an id from the
  /// moment it is created, before any database has seen it.
  final String id;

  /// The user's own name for the account. **Never translated** — it is their
  /// data, in their language.
  final String name;

  final AccountType type;

  /// ISO 4217 code. **Per account**, not per app.
  ///
  /// Accounts genuinely differ: a user may hold EGP locally and USD savings. A
  /// single app-wide currency would be a lie about their money.
  final String currencyCode;

  /// The figure this account leads with.
  double get headlineAmount;

  /// Whether [headlineAmount] represents money owed rather than money held.
  bool get isLiability;

  @override
  List<Object?> get props => <Object?>[id, name, type, currencyCode];

  @override
  bool get stringify => true;
}

/// An account that holds money: chequing, cash, savings.
final class DepositAccount extends AccountSummary {
  const DepositAccount({
    required super.id,
    required super.name,
    required super.type,
    required super.currencyCode,
    required this.balance,
  });

  /// What is in the account. May be negative — an overdrawn chequing account is
  /// a real thing, and the type system should not pretend otherwise.
  final double balance;

  @override
  double get headlineAmount => balance;

  @override
  bool get isLiability => false;

  @override
  List<Object?> get props => <Object?>[...super.props, balance];
}

/// A credit card: a limit, and how much of it has been spent.
final class CreditCardAccount extends AccountSummary {
  const CreditCardAccount({
    required super.id,
    required super.name,
    required super.currencyCode,
    required this.creditLimit,
    required this.usedAmount,
  }) : super(type: AccountType.creditCard);

  /// The ceiling.
  final double creditLimit;

  /// How much of the ceiling has been spent. Money **owed**.
  final double usedAmount;

  /// What is left to spend.
  ///
  /// Computed, never stored. Three numbers where two would do is three numbers
  /// that can disagree — and the one that disagrees is always the one on screen.
  double get availableCredit => creditLimit - usedAmount;

  /// Fraction of the limit that has been used, `0.0`–`1.0`.
  ///
  /// Guarded against a zero limit, which is a real state — a card that has been
  /// frozen — and would otherwise produce `NaN` and render as a blank bar.
  double get utilisation =>
      creditLimit > 0 ? (usedAmount / creditLimit).clamp(0.0, 1.0) : 0;

  /// The card leads with what is *available*, not what is owed — which is what a
  /// user is actually asking when they look at a credit card. The debt is shown
  /// immediately beneath it, never hidden.
  @override
  double get headlineAmount => availableCredit;

  @override
  bool get isLiability => true;

  @override
  List<Object?> get props =>
      <Object?>[...super.props, creditLimit, usedAmount];
}
