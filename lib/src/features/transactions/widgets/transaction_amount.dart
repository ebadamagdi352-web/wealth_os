import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/transactions/models/transaction_summary.dart';

/// Renders a transaction's amount: sign, currency, figure, colour.
///
/// ## The sign is the meaning. The colour is only the speed.
///
/// Every amount carries an explicit `+` or `−`. Colour is a **second, redundant**
/// signal, never the only one.
///
/// Roughly one man in twelve has red-green colour deficiency. A ledger that
/// separates income from expense *solely* by green and red is unreadable to them —
/// and they will not file a bug, they will simply misread their own money.
///
/// ## Transfers are neutral, and that is the point of having a `kind`
///
/// A transfer out of an account is negative, so if colour came from the sign it
/// would be red. "Moved 5,000 into savings" would look identical to "lost 5,000".
///
/// It is not a loss. Your net worth is unchanged; only its shape moved. The colour
/// comes from [TransactionKind], which knows that, rather than from the sign,
/// which does not.
class TransactionAmount extends StatelessWidget {
  const TransactionAmount({
    required this.amount,
    required this.currencyCode,
    required this.kind,
    super.key,
  });

  /// Signed. Positive is money in.
  final double amount;

  /// ISO 4217 code, e.g. `EGP`.
  final String currencyCode;

  /// What the transaction means. Chooses the colour.
  final TransactionKind kind;

  static final NumberFormat _format = NumberFormat.decimalPattern('en');

  /// U+2212 MINUS SIGN, not the hyphen on the keyboard.
  ///
  /// A hyphen is narrower than a plus sign, so a column of amounts written with
  /// one fails to align — and misaligned money is the fastest way for a finance
  /// product to look untrustworthy. Paired with tabular figures, the whole column
  /// locks to a grid.
  static const String _minus = '\u2212';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isCredit = amount >= 0;
    final String sign = isCredit ? '+' : _minus;
    final String figure = _format.format(amount.abs());

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Flexible(
          child: Text(
            '$sign $figure',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorFor(theme.brightness, kind),
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ),
        AppSpacing.gapH4,
        Text(
          currencyCode,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// The colour for [kind] at the active [brightness].
  ///
  /// Exposed so the same rule can be reused — a chart, a summary row, a running
  /// total — without any of them re-deciding what green means.
  ///
  /// These live in [AppColors] as plain constants rather than in the
  /// `ColorScheme`, because Material has no role meaning "this number went up".
  /// The correct long-term home is a `ThemeExtension`; until it exists, the branch
  /// lives here, in one place, rather than at every call site.
  static Color colorFor(Brightness brightness, TransactionKind kind) {
    final bool isDark = brightness == Brightness.dark;
    return switch (kind) {
      TransactionKind.income =>
        isDark ? AppColors.darkGain : AppColors.lightGain,
      TransactionKind.expense =>
        isDark ? AppColors.darkLoss : AppColors.lightLoss,
      TransactionKind.transfer =>
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    };
  }
}
