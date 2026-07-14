import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/assets/models/asset_summary.dart';

/// Renders an asset's performance: arrow, sign, percentage, colour.
///
/// The single place the performance-display rules live, so a chart, a summary
/// row, or a detail screen can reuse them without re-deciding what green means or
/// which way the arrow points.
///
/// ## The arrow and the sign carry the meaning; the colour only adds speed
///
/// Up is `+`, an upward arrow, and green. Down is `−` (U+2212, not a hyphen), a
/// downward arrow, and red. Flat is no sign, no arrow, and grey.
///
/// The arrow and sign are not decoration on top of the colour — they are the
/// primary signal, and the colour is redundant with them. Roughly one man in
/// twelve cannot separate the green from the red, and for them the arrow is the
/// only thing on the chip that means anything. A performance indicator that
/// encodes direction in colour alone is unreadable to them, and they will misread
/// their own portfolio without ever knowing a signal was there.
class AssetPerformance extends StatelessWidget {
  const AssetPerformance({
    required this.performance,
    required this.trend,
    this.filled = false,
    super.key,
  });

  /// Performance as a fraction: `0.082` is +8.2%.
  final double performance;

  final AssetTrend trend;

  /// When true, the chip gets a tinted pill background. Used on the card, where
  /// the figure needs to stand away from the value beside it.
  final bool filled;

  static final NumberFormat _percent = NumberFormat.decimalPercentPattern(
    locale: 'en',
    decimalDigits: 1,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = colorFor(theme.brightness, trend);

    final String text = '${_signFor(trend)}${_percent.format(performance.abs())}';

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(_iconFor(trend), size: 14, color: color),
        AppSpacing.gapH4,
        Text(
          text,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );

    if (!filled) {
      return content;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.borderPill,
      ),
      child: content,
    );
  }

  /// The colour for [trend] at the active [brightness].
  ///
  /// These live in [AppColors] as plain constants rather than in the
  /// `ColorScheme`, because Material has no role meaning "this went up". The
  /// long-term home is a `ThemeExtension`; until it exists, the branch lives here,
  /// once, rather than at every call site.
  static Color colorFor(Brightness brightness, AssetTrend trend) {
    final bool isDark = brightness == Brightness.dark;
    return switch (trend) {
      AssetTrend.up => isDark ? AppColors.darkGain : AppColors.lightGain,
      AssetTrend.down => isDark ? AppColors.darkLoss : AppColors.lightLoss,
      // Grey, from the theme rather than a constant — a neutral has no semantic
      // colour, it is simply absent of one.
      AssetTrend.flat =>
        isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant,
    };
  }

  static String _signFor(AssetTrend trend) => switch (trend) {
        AssetTrend.up => '+',
        AssetTrend.down => '\u2212',
        AssetTrend.flat => '',
      };

  static IconData _iconFor(AssetTrend trend) => switch (trend) {
        AssetTrend.up => Icons.arrow_upward,
        AssetTrend.down => Icons.arrow_downward,
        AssetTrend.flat => Icons.remove,
      };
}
