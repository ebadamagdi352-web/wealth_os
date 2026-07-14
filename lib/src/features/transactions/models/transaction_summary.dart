import 'package:equatable/equatable.dart';

/// What a transaction *means*, which is not the same as which way the money went.
///
/// The colour on the card is chosen from this, not from the sign of the amount.
/// The two are related but neither derives the other:
///
/// * [income] is always positive.
/// * [expense] is always negative.
/// * [transfer] may be **either** — money leaving one account is money arriving
///   in another, and both halves are transfers.
///
/// That last case is the reason this enum exists at all. If colour were chosen
/// from the sign, every outbound transfer would be painted red — and "moved
/// 5,000 into savings" would look exactly like "lost 5,000". In a wealth product
/// those are opposite events: one changes your net worth, the other does not.
enum TransactionKind {
  income,
  expense,

  /// Money moved between things you own. Net worth unchanged.
  transfer,
}

/// What the transaction was for.
///
/// [displayLabel] is **not localized**. The ARB files hold four keys and none of
/// them are these; localization has been out of scope for seven consecutive
/// tasks. When the keys exist this becomes `labelKey`.
enum TransactionCategory {
  income(iconKey: 'income', displayLabel: 'Income'),
  investment(iconKey: 'investment', displayLabel: 'Investment'),
  utilities(iconKey: 'utilities', displayLabel: 'Utilities'),
  groceries(iconKey: 'groceries', displayLabel: 'Groceries'),
  transfer(iconKey: 'transfer', displayLabel: 'Transfer');

  const TransactionCategory({
    required this.iconKey,
    required this.displayLabel,
  });

  /// Stable identifier for the icon. A string, not an `IconData`, so this file
  /// stays pure Dart and can be unit-tested without a widget binding.
  final String iconKey;

  /// Human-readable label. Not localized — see the enum doc.
  final String displayLabel;
}

/// One movement of money.
///
/// ## Why this is a plain class, when `AccountSummary` is `sealed`
///
/// Accounts needed a sealed hierarchy because a credit card is **structurally**
/// different from a chequing account: it has a limit and a used amount where the
/// other has a balance, and a single class would have made illegal states
/// representable.
///
/// A transaction has no such split. Income, expense and transfer all have exactly
/// the same fields — a title, an amount, a currency, a date. What differs is the
/// *meaning*, not the *shape*. Meaning is an enum; shape is a hierarchy. Sealing
/// this would be ceremony with no payoff, and three near-identical subclasses is
/// how a codebase gets heavy without getting safer.
class TransactionSummary extends Equatable {
  /// The constructor is `const`, and the asserts survived — see the note on
  /// [amount] for why that combination needed a trick.
  const TransactionSummary({
    required this.id,
    required this.title,
    required this.amount,
    required this.currencyCode,
    required this.kind,
    required this.category,
    required this.occurredAt,
  })  : assert(
          !(identical(kind, TransactionKind.income) && amount < 0),
          'An income transaction cannot have a negative amount.',
        ),
        assert(
          !(identical(kind, TransactionKind.expense) && amount > 0),
          'An expense transaction cannot have a positive amount.',
        );

  /// Stable identifier. Generated client-side, so a transaction has an id from
  /// the moment it is created — before any database has seen it.
  final String id;

  /// The user's own description. **Never translated** — their data, their words.
  final String title;

  /// Signed. Positive is money in, negative is money out.
  ///
  /// A signed number rather than a magnitude plus a direction flag. Two fields can
  /// contradict each other — `amount: 50, isOutgoing: true` is representable — and
  /// one cannot.
  ///
  /// ## The asserts, and why they use `identical`
  ///
  /// The constructor asserts that the sign agrees with [kind]: income cannot be
  /// negative, expense cannot be positive. Transfers are exempt, because both
  /// directions are legitimate.
  ///
  /// An `assert` inside a **`const`** constructor must be a *potentially constant
  /// expression*, and Dart's rules there are narrower than they look. Const `==`
  /// is permitted only for `null`, `bool`, `num`, `String` and `Symbol` — **not for
  /// enums.** So the obvious `kind == TransactionKind.income` does not compile in a
  /// const constructor.
  ///
  /// `identical()` *is* permitted, and enum values are canonical instances, so
  /// `identical(kind, TransactionKind.income)` is exactly equivalent and is const-
  /// evaluable. The numeric comparisons (`< 0`, `> 0`) were already fine.
  ///
  /// The alternative was to drop the asserts, or to drop `const`. Neither is
  /// necessary: this keeps both the compile-time constructor and the runtime
  /// invariant.
  final double amount;

  /// ISO 4217 code. Per transaction, because a user may spend in more than one.
  final String currencyCode;

  /// What the transaction means. Drives the colour.
  final TransactionKind kind;

  /// What it was for. Drives the icon and the label.
  final TransactionCategory category;

  /// When it happened.
  ///
  /// A `DateTime`, not the string `"Yesterday"`. A stored label is frozen the
  /// moment it is written: tomorrow it still says "Yesterday", and it is wrong.
  /// Relative dates are a **rendering** decision, and they are recomputed on every
  /// build against the current clock.
  ///
  /// Note that a `DateTime` cannot itself be `const`, so no caller can actually
  /// *invoke* this constructor in a constant context. The constructor is still
  /// declared `const` because the analyzer requires it of an `@immutable` class —
  /// and because the day a factory or a test builds one from constant inputs, it
  /// costs nothing to have been ready.
  final DateTime occurredAt;

  /// Whether money came in.
  bool get isCredit => amount >= 0;

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        amount,
        currencyCode,
        kind,
        category,
        occurredAt,
      ];

  @override
  bool get stringify => true;
}
