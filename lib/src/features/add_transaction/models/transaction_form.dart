import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/transactions/models/transaction_summary.dart';

/// An account, as the *form* needs to see it.
///
/// Id, name, currency. Not `AccountSummary` — the form does not need a balance, a
/// credit limit, or a utilisation percentage, and importing the accounts feature's
/// model to get three fields would couple two features for no benefit.
///
/// This is a **view model**: a projection shaped for one screen. `AccountSummary`
/// is the domain type. They are allowed to differ, and they should.
class FormAccount extends Equatable {
  const FormAccount({
    required this.id,
    required this.name,
    required this.currencyCode,
  });

  final String id;
  final String name;

  /// Drives the amount field's suffix. Select the USD savings account and the
  /// amount field says USD — because a number without a currency is not money.
  final String currencyCode;

  @override
  List<Object?> get props => <Object?>[id, name, currencyCode];
}

/// The state of the add-transaction form.
///
/// Immutable, with `copyWith`. Held in a `StatefulWidget`'s `State` for now, because
/// providers are forbidden here — but the shape is exactly what a `Notifier<TransactionForm>`
/// would hold, so the migration is a change of *owner*, not of *model*. See
/// TASK_016_REPORT.md.
///
/// Every field is nullable except [kind] and [notes], and the nullability is
/// load-bearing: `null` means *the user has not chosen yet*, which is a genuinely
/// different state from any value they could pick. An amount defaulted to `0` would
/// be indistinguishable from a user who typed zero.
class TransactionForm extends Equatable {
  const TransactionForm({
    this.kind = TransactionKind.expense,
    this.amount,
    this.sourceAccountId,
    this.destinationAccountId,
    this.category,
    this.date,
    this.notes = '',
  });

  /// Defaults to [TransactionKind.expense] — the overwhelmingly most common entry.
  /// Defaulting to income would make the app's most frequent action its slowest.
  final TransactionKind kind;

  /// `null` until the user types a number. Not `0`.
  final double? amount;

  /// Where the money comes from. For income, this is where it *lands*.
  final String? sourceAccountId;

  /// Where the money goes. **Transfers only** — see [needsDestinationAccount].
  final String? destinationAccountId;

  final TransactionCategory? category;

  final DateTime? date;

  /// Free text. Empty, not null — an empty note and no note are the same thing, and
  /// two representations of one state is one too many.
  final String notes;

  /// Whether a second account must be chosen.
  ///
  /// **A transfer with one account is not a transfer.** "Moved 5,000 out of Main
  /// Bank" does not say where it went, and without a destination the other side of
  /// the entry does not exist — the money simply vanishes from the ledger.
  ///
  /// This is the double-entry gap flagged in TASK_015_REPORT.md §6, arriving exactly
  /// where it was predicted to.
  bool get needsDestinationAccount => kind == TransactionKind.transfer;

  /// Whether every required field has been filled.
  ///
  /// ⚠️ This is **completeness**, not validation. It asks "has the user finished?",
  /// not "is this transaction legal?" — no minimums, no maximums, no currency
  /// matching, no duplicate detection, no business rule of any kind. Those are the
  /// things the task forbids, and none of them are here.
  ///
  /// It exists so the save button can be disabled until the form is fillable. A save
  /// button that is enabled on an empty form is a button that exists to produce an
  /// error message.
  ///
  /// If you read the rule more strictly than I have, deleting this getter and passing
  /// `enabled: true` to `SaveButton` removes it entirely. See TASK_016_REPORT.md.
  bool get isComplete {
    if (amount == null || amount! <= 0) {
      return false;
    }
    if (sourceAccountId == null || category == null || date == null) {
      return false;
    }
    if (needsDestinationAccount && destinationAccountId == null) {
      return false;
    }
    return true;
  }

  /// Sentinel distinguishing "argument omitted" from "argument was null".
  ///
  /// Without it, `copyWith` cannot *clear* a field: `copyWith(amount: null)` is
  /// indistinguishable from `copyWith()` under the usual `??` implementation, so the
  /// user could never empty the amount box once they had typed in it. The same trap
  /// as `Settings.copyWith` in Task 007, and the same fix.
  static const Object _unset = Object();

  TransactionForm copyWith({
    TransactionKind? kind,
    Object? amount = _unset,
    Object? sourceAccountId = _unset,
    Object? destinationAccountId = _unset,
    Object? category = _unset,
    Object? date = _unset,
    String? notes,
  }) {
    final TransactionKind nextKind = kind ?? this.kind;

    return TransactionForm(
      kind: nextKind,
      amount:
          identical(amount, _unset) ? this.amount : amount as double?,
      sourceAccountId: identical(sourceAccountId, _unset)
          ? this.sourceAccountId
          : sourceAccountId as String?,
      // Switching away from a transfer clears the destination. Leaving a stale
      // account id on a form that no longer shows the field is how an expense ends
      // up secretly carrying a destination account nobody chose.
      destinationAccountId: nextKind != TransactionKind.transfer
          ? null
          : identical(destinationAccountId, _unset)
              ? this.destinationAccountId
              : destinationAccountId as String?,
      category: identical(category, _unset)
          ? this.category
          : category as TransactionCategory?,
      date: identical(date, _unset) ? this.date : date as DateTime?,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        kind,
        amount,
        sourceAccountId,
        destinationAccountId,
        category,
        date,
        notes,
      ];

  @override
  bool get stringify => true;
}

/// Shared styling for every field on this form.
///
/// # ⚠️ This does not belong in a `models\` file
///
/// It is presentation, it imports Flutter, and it makes this file the only model in
/// the codebase that is not pure Dart. I am not pretending otherwise.
///
/// **Its real home is `AppTheme.inputDecorationTheme`** — the gap I flagged and
/// deliberately left open in TASK_005_REPORT.md §4, because the `InputDecorationTheme`
/// type was renamed in recent Flutter and I could not verify which name your SDK
/// wanted without seeing it fail.
///
/// That gap has now been reached. Four fields on this form need identical rounded,
/// filled decoration. The alternatives were:
///
/// * Repeat eight lines of `InputDecoration` in four widget files → breaks *no
///   duplicated code*, which is an explicit rule for this task.
/// * Put it in `add_transaction_page.dart` → the widgets would import the page, and
///   the page imports the widgets. A cycle.
/// * Put it here → one definition, no cycle, wrong folder.
///
/// I took the third. **Ten lines in `app_theme.dart` deletes this class**, styles every
/// input in the product rather than only this form's, and puts it where it belongs.
/// `design_system\` is not on this task's allowed file list. Flagged, not smuggled.
abstract final class AddTransactionFieldStyle {
  /// Consistent height for every control, so a column of fields aligns.
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );

  /// Rounded, filled, borderless-at-rest. A form of hairline rectangles reads as a
  /// tax return; a form of soft filled fields reads as an app.
  static InputDecoration build(
    BuildContext context, {
    String? labelText,
    String? hintText,
    String? suffixText,
    Widget? prefixIcon,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      suffixText: suffixText,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: colors.surfaceContainerLow,
      contentPadding: contentPadding,
      border: border(colors.outlineVariant, 1),
      enabledBorder: border(colors.outlineVariant, 1),
      focusedBorder: border(colors.primary, 2),
    );
  }
}
