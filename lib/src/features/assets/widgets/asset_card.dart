import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/assets/models/asset_summary.dart';
import 'package:wealth_os/src/features/assets/widgets/asset_performance.dart';

/// One asset.
///
/// Icon, name, value, performance — in that reading order: *what is it, how much
/// is it worth, which way is it going.*
class AssetCard extends StatelessWidget {
  const AssetCard({required this.asset, super.key});

  final AssetSummary asset;

  static final NumberFormat _format = NumberFormat.decimalPattern('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Brightness brightness = theme.brightness;
    final bool isDark = brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardAll,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderCard,
        // Shadow in light, border in dark — never both. A black shadow on a
        // near-black surface is invisible, so dark mode separates by edge.
        boxShadow: AppShadows.card(brightness),
        border: isDark ? Border.all(color: colors.outlineVariant) : null,
      ),
      child: Row(
        children: <Widget>[
          _AssetIcon(iconKey: asset.iconKey),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  asset.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                AppSpacing.gapV4,
                AssetPerformance(
                  performance: asset.performance,
                  trend: asset.trend,
                  filled: true,
                ),
              ],
            ),
          ),
          AppSpacing.gapH8,
          // Value leads the right edge; the currency sits smaller beneath it. A
          // number without its currency is not money.
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _format.format(asset.value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
              Text(
                asset.currencyCode,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Resolves an [AssetSummary.iconKey] to a Material icon.
///
/// The indirection keeps `asset_summary.dart` free of Flutter. The keys match the
/// dashboard's asset summary (Task 012), so gold, stocks, cash and real estate
/// wear the same glyph on both screens — a holding that changed icon between two
/// views would read as two different things.
abstract final class AssetIcons {
  static const Map<String, IconData> _icons = <String, IconData>{
    'gold': Icons.diamond_outlined,
    'stocks': Icons.show_chart,
    'cash': Icons.account_balance_wallet_outlined,
    'real_estate': Icons.home_work_outlined,
  };

  /// Fallback for a key with no mapping. Visually obvious, so an unmapped key
  /// gets noticed rather than silently tolerated.
  static const IconData fallback = Icons.category_outlined;

  static IconData forKey(String iconKey) => _icons[iconKey] ?? fallback;
}

/// The tinted icon chip.
class _AssetIcon extends StatelessWidget {
  const _AssetIcon({required this.iconKey});

  final String iconKey;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: AppRadius.borderMd,
      ),
      child: Icon(
        AssetIcons.forKey(iconKey),
        size: 20,
        color: colors.onPrimaryContainer,
      ),
    );
  }
}
