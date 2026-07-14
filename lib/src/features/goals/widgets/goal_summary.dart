import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/goals/models/financial_goal.dart';

/// The three-number headline: how many goals, how many done, how far along.
///
/// Every figure is **computed from the list** — nothing is passed in pre-totalled.
/// A summary handed its own numbers is a summary that can disagree with the cards
/// beneath it; a summary that derives them cannot.
///
/// ## ⚠️ "Average Progress" is the mean of the goals' percentages — a choice
///
/// There are two honest numbers this label could show, and they are far apart:
///
/// * **Mean of each goal's completion** — every goal counts once, regardless of
///   size. That is this widget. For the mock it is ~50%.
/// * **Aggregate funding ratio** — total saved over total targeted, which weights
///   by size. For the mock it is ~25%, because a barely-started 8,000,000
///   retirement goal swamps five smaller ones.
///
/// They answer different questions: *"how far along are my goals, on average?"*
/// versus *"how much of everything I'm reaching for is funded?"* The label says
/// "average progress", so I took the plain average — each goal is a thing you are
/// making progress on, and each counts once. If the product wants the funding
/// ratio, it is `sumCurrent / sumTarget`, and the label should change to match.
/// Flagged in TASK_018_REPORT.md.
class GoalSummary extends StatelessWidget {
  const GoalSummary({
    required this.goals,
    required this.totalLabel,
    required this.completedLabel,
    required this.averageLabel,
    super.key,
  });

  final List<FinancialGoal> goals;
  final String totalLabel;
  final String completedLabel;
  final String averageLabel;

  static final NumberFormat _percent = NumberFormat.decimalPercentPattern(
    locale: 'en',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Brightness brightness = theme.brightness;
    final bool isDark = brightness == Brightness.dark;

    final int total = goals.length;
    final int completed =
        goals.where((FinancialGoal goal) => goal.isComplete).length;

    // Mean of clamped progress. Empty guarded — `reduce` throws on an empty list,
    // and a user with no goals has an average progress of nothing, shown as 0%.
    final double average = goals.isEmpty
        ? 0
        : goals
                .map((FinancialGoal goal) => goal.progressClamped)
                .reduce((double a, double b) => a + b) /
            goals.length;

    return Container(
      padding: AppSpacing.cardAll,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderCard,
        boxShadow: AppShadows.card(brightness),
        border: isDark ? Border.all(color: colors.outlineVariant) : null,
      ),
      child: IntrinsicHeight(
        // So the two dividers take the full height of the tallest column.
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: _Stat(value: '$total', label: totalLabel),
            ),
            _Divider(color: colors.outlineVariant),
            Expanded(
              child: _Stat(value: '$completed', label: completedLabel),
            ),
            _Divider(color: colors.outlineVariant),
            Expanded(
              child: _Stat(
                value: _percent.format(average),
                label: averageLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
        AppSpacing.gapV4,
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: VerticalDivider(width: 1, thickness: 1, color: color),
    );
  }
}
