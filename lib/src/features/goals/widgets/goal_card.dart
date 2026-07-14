import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/goals/models/financial_goal.dart';
import 'package:wealth_os/src/features/goals/widgets/goal_progress.dart';

/// One goal.
///
/// Reads top to bottom the way the question does: *what am I saving for, how far
/// am I, and how much is left.* Icon and name, then the amounts, then the bar,
/// then the footer — remaining or done on the left, the target date on the right
/// when there is one.
class GoalCard extends StatelessWidget {
  const GoalCard({required this.goal, super.key});

  final FinancialGoal goal;

  static final NumberFormat _amount = NumberFormat.decimalPattern('en');
  static final DateFormat _date = DateFormat.yMMM('en');

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
        // Shadow in light, hairline border in dark — never both. A shadow is
        // invisible against a near-black surface, so dark mode separates by edge.
        boxShadow: AppShadows.card(brightness),
        border: isDark ? Border.all(color: colors.outlineVariant) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _GoalIcon(iconKey: goal.iconKey),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      goal.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    AppSpacing.gapV4,
                    // "185,000 of 300,000 EGP" — the saved amount leads because it
                    // is the one that moves; the target is context for it.
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: _amount.format(goal.currentAmount),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                          ),
                          TextSpan(
                            text: ' ${GoalCardCopy.of} '
                                '${_amount.format(goal.targetAmount)} '
                                '${goal.currencyCode}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapV16,
          GoalProgress(
            progress: goal.progress,
            isComplete: goal.isComplete,
          ),
          AppSpacing.gapV12,
          _Footer(goal: goal, dateLabel: _dateLabel(goal)),
        ],
      ),
    );
  }

  String? _dateLabel(FinancialGoal goal) =>
      goal.targetDate == null ? null : _date.format(goal.targetDate!);
}

/// Remaining-or-done on the left, target date on the right.
class _Footer extends StatelessWidget {
  const _Footer({required this.goal, required this.dateLabel});

  final FinancialGoal goal;
  final String? dateLabel;

  static final NumberFormat _amount = NumberFormat.decimalPattern('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    final String leftText = goal.isComplete
        ? GoalCardCopy.goalReached
        : '${_amount.format(goal.remaining)} ${goal.currencyCode} '
            '${GoalCardCopy.toGo}';

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            leftText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        if (dateLabel != null) ...<Widget>[
          AppSpacing.gapH8,
          Icon(
            Icons.event_outlined,
            size: 14,
            color: colors.onSurfaceVariant,
          ),
          AppSpacing.gapH4,
          Text(
            dateLabel!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Resolves a [FinancialGoal.iconKey] to a Material icon.
///
/// The indirection keeps `financial_goal.dart` free of Flutter.
abstract final class GoalIcons {
  static const Map<String, IconData> _icons = <String, IconData>{
    'emergency_fund': Icons.shield_outlined,
    'apartment': Icons.apartment,
    'car': Icons.directions_car_outlined,
    'retirement': Icons.beach_access_outlined,
    'travel': Icons.flight_takeoff,
    'laptop': Icons.laptop_mac,
  };

  /// Fallback for an unmapped key — visibly generic, so a missing mapping gets
  /// noticed rather than silently tolerated.
  static const IconData fallback = Icons.flag_outlined;

  static IconData forKey(String iconKey) => _icons[iconKey] ?? fallback;
}

/// The tinted icon chip.
class _GoalIcon extends StatelessWidget {
  const _GoalIcon({required this.iconKey});

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
        GoalIcons.forKey(iconKey),
        size: 20,
        color: colors.onPrimaryContainer,
      ),
    );
  }
}

/// Copy owned by the goal card. Not localized — see `GoalsCopy`.
abstract final class GoalCardCopy {
  static const String of = 'of';
  static const String toGo = 'to go';
  static const String goalReached = 'Goal reached';
}
