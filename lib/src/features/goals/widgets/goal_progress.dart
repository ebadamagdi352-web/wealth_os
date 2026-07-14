import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';

/// A goal's progress: the percentage, then the bar.
///
/// The single place the progress-display rules live, so the card, the summary, or
/// a future detail screen show one identical bar rather than three that drift.
///
/// ## Built by hand, not from `LinearProgressIndicator`
///
/// `LinearProgressIndicator` gained a `borderRadius` parameter only recently, and
/// this file cannot know which SDK it will be compiled against. Two `Container`s
/// under a `ClipRRect` need no version I cannot see — the rounded ends come from
/// the clip, and the fill width from a `LayoutBuilder` that reads the real
/// available width rather than guessing. Fewer moving parts than the built-in, and
/// no version gamble.
///
/// ## The percentage is rounded; the bar is not
///
/// The label shows a whole number — `62%` — because a goal card is a glance, not a
/// spreadsheet. The **bar**, though, is drawn from the unrounded fraction, so a
/// goal at 61.6% and one at 62.4% both label "62%" but fill to visibly different
/// widths. Rounding the bar as well as the label would throw away the only
/// precision the bar exists to show.
class GoalProgress extends StatelessWidget {
  const GoalProgress({
    required this.progress,
    required this.isComplete,
    this.barHeight = 8,
    super.key,
  });

  /// Raw fraction. Clamped internally for the bar; the label rounds it.
  final double progress;

  /// Drives the fill colour — a met goal is not merely "100% of the way to
  /// unmet", it is *done*, and green says so where the accent colour would not.
  final bool isComplete;

  final double barHeight;

  static final NumberFormat _percent = NumberFormat.decimalPercentPattern(
    locale: 'en',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final double clamped = progress.clamp(0.0, 1.0).toDouble();

    final Color fill = isComplete
        ? (isDark ? AppColors.darkGain : AppColors.lightGain)
        : colors.primary;
    final Color track = colors.surfaceContainerHighest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (isComplete)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check_circle, size: 15, color: fill),
                  AppSpacing.gapH4,
                  Text(
                    GoalProgressCopy.completed,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: fill,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else
              const SizedBox.shrink(),
            Text(
              // Clamped so an over-funded goal reads "100%", not "120%". Completion
              // tops out at done.
              _percent.format(clamped),
              style: theme.textTheme.labelMedium?.copyWith(
                color: isComplete ? fill : colors.onSurface,
                fontWeight: FontWeight.w600,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ),
        AppSpacing.gapV8,
        ClipRRect(
          borderRadius: AppRadius.borderPill,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              return Stack(
                children: <Widget>[
                  Container(width: width, height: barHeight, color: track),
                  Container(
                    width: width * clamped,
                    height: barHeight,
                    color: fill,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Copy owned by the progress widget. Not localized — see `GoalsCopy`.
abstract final class GoalProgressCopy {
  static const String completed = 'Completed';
}
