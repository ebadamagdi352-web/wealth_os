import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';

/// One holding in the [AssetSummary] card.
class AssetHolding extends Equatable {
  const AssetHolding({
    required this.name,
    required this.amount,
    required this.icon,
  });

  final String name;

  /// Value of the holding, in the dashboard's currency.
  final double amount;

  final IconData icon;

  @override
  List<Object?> get props => <Object?>[name, amount, icon];
}

/// The asset breakdown: what the money is made of.
///
/// Each row shows its share of the total as a bar. The **share is computed from
/// the holdings**, never passed in — a percentage supplied alongside an amount is
/// a second source of truth for the same fact, and the two will eventually
/// disagree. Here, they cannot.
///
/// The bar is not decoration. A column of numbers tells you the amounts; the bars
/// tell you the *shape* of the portfolio at a glance, which is the question a user
/// actually has.
class AssetSummary extends StatelessWidget {
  const AssetSummary({
    required this.title,
    required this.holdings,
    required this.currencyCode,
    super.key,
  });

  final String title;
  final List<AssetHolding> holdings;
  final String currencyCode;

  static final NumberFormat _amountFormat = NumberFormat.decimalPattern('en');
  static final NumberFormat _percentFormat = NumberFormat.decimalPercentPattern(
    locale: 'en',
    decimalDigits: 1,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Brightness brightness = theme.brightness;
    final bool isDark = brightness == Brightness.dark;

    final double total = holdings.fold<double>(
      0,
      (double sum, AssetHolding holding) => sum + holding.amount,
    );

    return Container(
      padding: AppSpacing.cardAll,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderCard,
        // Shadow in light, border in dark — never both. A black shadow on a
        // near-black surface is invisible, so dark mode separates by edge
        // instead. See AppShadows.
        boxShadow: AppShadows.card(brightness),
        border: isDark ? Border.all(color: colors.outlineVariant) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.textTheme.titleMedium),
          AppSpacing.gapV16,
          for (int i = 0; i < holdings.length; i++) ...<Widget>[
            if (i > 0) AppSpacing.gapV16,
            _AssetRow(
              holding: holdings[i],
              // Guarded, because a total of zero is a real state — a new user
              // with no assets — and dividing by it would render every bar as NaN
              // rather than as empty.
              share: total > 0 ? holdings[i].amount / total : 0,
              currencyCode: currencyCode,
              amountFormat: _amountFormat,
              percentFormat: _percentFormat,
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.holding,
    required this.share,
    required this.currencyCode,
    required this.amountFormat,
    required this.percentFormat,
  });

  final AssetHolding holding;
  final double share;
  final String currencyCode;
  final NumberFormat amountFormat;
  final NumberFormat percentFormat;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: AppRadius.borderSm,
              ),
              child: Icon(
                holding.icon,
                size: 18,
                color: colors.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapH12,
            Expanded(
              child: Text(
                holding.name,
                style: theme.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.gapH8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '$currencyCode ${amountFormat.format(holding.amount)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
                Text(
                  percentFormat.format(share),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
        ),
        AppSpacing.gapV8,
        ClipRRect(
          borderRadius: AppRadius.borderXs,
          child: LinearProgressIndicator(
            value: share,
            minHeight: 5,
            backgroundColor: colors.surfaceContainerHigh,
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}
