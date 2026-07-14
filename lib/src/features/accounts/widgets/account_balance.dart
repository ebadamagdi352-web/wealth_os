import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';

/// How much visual weight a balance carries.
enum BalanceEmphasis {
  /// The account's headline figure.
  primary,

  /// A supporting figure — a limit, an available amount.
  secondary,
}

/// Renders a monetary amount with its currency.
///
/// Exists as its own widget for one reason: **money must never be formatted twice
/// in two places.** The moment a balance is built inline with a `Text` here and a
/// `Text` there, one of them gets grouping separators and the other does not, one
/// rounds and the other truncates, and the app starts quietly disagreeing with
/// itself about how much money someone has.
///
/// Every rule about rendering an amount lives here:
///
/// * `NumberFormat`, never string interpolation — `'$amount'` renders `520000.0`.
/// * Tabular figures, so a column of amounts aligns. With proportional figures a
///   `1` is narrower than a `0` and the column ragged-edges, which reads as
///   sloppiness in a product whose entire job is arithmetic.
/// * The currency code is set smaller and quieter than the figure, on a shared
///   baseline. `EGP 520,000` as one uniform string makes the eye read the code
///   first; separating them lets the number lead.
class AccountBalance extends StatelessWidget {
  const AccountBalance({
    required this.currencyCode,
    required this.amount,
    this.label,
    this.emphasis = BalanceEmphasis.primary,
    this.color,
    this.alignment = CrossAxisAlignment.end,
    super.key,
  });

  /// ISO 4217 code, e.g. `EGP`.
  final String currencyCode;

  /// The figure. May be negative — an overdrawn account is a real thing.
  final double amount;

  /// Optional caption above the figure, e.g. "Available".
  final String? label;

  final BalanceEmphasis emphasis;

  /// Overrides the figure's colour. Used for gain/loss, and for type on the ink
  /// hero surface.
  final Color? color;

  final CrossAxisAlignment alignment;

  static final NumberFormat _format = NumberFormat.decimalPattern('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    final bool isPrimary = emphasis == BalanceEmphasis.primary;

    final TextStyle? amountStyle = (isPrimary
            ? theme.textTheme.titleMedium
            : theme.textTheme.bodySmall)
        ?.copyWith(
      color: color ?? (isPrimary ? colors.onSurface : colors.onSurfaceVariant),
      fontFeatures: AppTypography.tabularFigures,
    );

    final TextStyle? codeStyle = (isPrimary
            ? theme.textTheme.labelMedium
            : theme.textTheme.bodySmall)
        ?.copyWith(
      color: color?.withValues(alpha: 0.75) ?? colors.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (label != null) ...<Widget>[
          Text(
            label!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapV4,
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(currencyCode, style: codeStyle),
            AppSpacing.gapH4,
            Flexible(
              child: Text(
                _format.format(amount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: amountStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
