import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// The hero figure: total net worth.
///
/// One number, given room to breathe. This is the only thing on the screen a
/// user opens the app to see, and a card that competes with it — a sparkline, a
/// percentage badge, a "vs last month" chip — makes it harder to read, not
/// richer.
///
/// It shows no change indicator, deliberately. The mock data contains no
/// historical figure, so any percentage here would be invented, and an invented
/// number in a finance product is not a placeholder, it is a lie with a decimal
/// point.
class NetWorthCard extends StatelessWidget {
  const NetWorthCard({
    required this.label,
    required this.amount,
    required this.currencyCode,
    super.key,
  });

  /// e.g. "Total Net Worth".
  final String label;

  /// The figure, in [currencyCode].
  final double amount;

  /// ISO 4217 code, e.g. `EGP`.
  final String currencyCode;

  /// Grouping separators, no decimals.
  ///
  /// Money is never formatted by string interpolation. `'$amount'` would render
  /// `1245300.0` — which is both wrong and, in a wealth product, alarming.
  static final NumberFormat _format = NumberFormat.decimalPattern('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.x2l,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: AppRadius.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.onPrimaryContainer.withValues(alpha: 0.75),
            ),
          ),
          AppSpacing.gapV12,
          // The currency code sits on its own baseline, smaller than the figure.
          // Rendering "EGP 1,245,300" as one uniform string makes the eye read
          // the code first; separating them lets the number lead.
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                currencyCode,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onPrimaryContainer.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapH8,
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    _format.format(amount),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
