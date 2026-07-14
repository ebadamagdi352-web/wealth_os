import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/goals/models/financial_goal.dart';
import 'package:wealth_os/src/features/goals/widgets/empty_goals.dart';
import 'package:wealth_os/src/features/goals/widgets/goal_summary.dart';
import 'package:wealth_os/src/features/goals/widgets/goals_list.dart';
import 'package:wealth_os/src/localization/generated/app_localizations.dart';

/// Every string the goals screen renders.
///
/// Same confession as every feature before it: the ARB files hold four keys, none
/// of them these, and localization has been out of scope for ten consecutive
/// tasks. One class per feature keeps the eventual migration to one file and one
/// deletion.
///
/// * **This class is UI chrome** — it must become ARB keys.
/// * **Goal names are data** — "Emergency Fund", "Retirement". In a real app the
///   user writes these, in their own language, and they must **never** be
///   translated.
abstract final class GoalsCopy {
  static const String subtitle = 'Where you\'re headed';
  static const String title = 'Goals';

  static const String totalGoals = 'Total Goals';
  static const String completedGoals = 'Completed';
  static const String averageProgress = 'Avg. Progress';

  static const String emptyTitle = 'No goals yet';
  static const String emptyDescription =
      'Set a target — an emergency fund, a home, a trip — and watch how close '
      'you are getting with every contribution.';
  static const String emptyAction = 'Create a goal';
}

/// The goals screen.
///
/// Presentation only. No repository, no provider, no persistence, no network, no
/// CRUD. The goals below are constants in this file, passed down as parameters —
/// every widget beneath is a pure function of its arguments, which is what lets
/// them be reused unchanged when the data becomes real.
class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  /// Matches every other screen, so the app does not disagree with itself about
  /// how wide a page is as the user moves between tabs.
  static const double _maxContentWidth = 720;

  // ---------------------------------------------------------------------
  // MOCK DATA
  //
  // `static final`, not `const`: `DateTime` has no const constructor, so a list
  // holding target dates cannot be const. Same reason the transactions mock is
  // final (Task 015).
  //
  // The first five are the brief's goals. Their displayed percentages are
  // COMPUTED, so a couple differ from the brief's example numbers — Emergency Fund
  // shows 62% (185k/300k = 61.67%, which rounds up), where the brief wrote 61% (a
  // truncation). The brief's own examples mixed rounding and truncation; I round
  // consistently. See TASK_018_REPORT.md §3.
  // ---------------------------------------------------------------------
  static final List<FinancialGoal> _mockGoals = <FinancialGoal>[
    FinancialGoal(
      id: 'goal_emergency',
      name: 'Emergency Fund',
      currentAmount: 185000,
      targetAmount: 300000,
      currencyCode: 'EGP',
      iconKey: 'emergency_fund',
      // No date: an emergency fund is a standing target, not a deadline. Exercises
      // the null-date path on the card.
    ),
    FinancialGoal(
      id: 'goal_apartment',
      name: 'Buy Apartment',
      currentAmount: 920000,
      targetAmount: 3500000,
      currencyCode: 'EGP',
      iconKey: 'apartment',
      targetDate: DateTime(2028, 12, 31),
    ),
    FinancialGoal(
      id: 'goal_car',
      name: 'New Car',
      currentAmount: 410000,
      targetAmount: 900000,
      currencyCode: 'EGP',
      iconKey: 'car',
      targetDate: DateTime(2027, 6, 30),
    ),
    FinancialGoal(
      id: 'goal_retirement',
      name: 'Retirement',
      currentAmount: 1600000,
      targetAmount: 8000000,
      currencyCode: 'EGP',
      iconKey: 'retirement',
      targetDate: DateTime(2045, 1, 1),
    ),
    FinancialGoal(
      id: 'goal_travel',
      name: 'Travel',
      currentAmount: 70000,
      targetAmount: 150000,
      currencyCode: 'EGP',
      iconKey: 'travel',
      targetDate: DateTime(2026, 9, 1),
    ),

    // ⚠️ ADDED beyond the brief's five — and I want you to see it.
    //
    // The brief says "at least five" and asks the summary to show **Completed
    // Goals**. With the five above, none is complete, so that stat would read a
    // permanent 0 and the completed state — the green bar, the check, "Goal
    // reached" — would be code no screen ever shows. This one goal makes the stat
    // read 1 and demonstrates the state it was asked to display.
    //
    // Deleting this single entry returns the mock to exactly the brief's five.
    FinancialGoal(
      id: 'goal_laptop',
      name: 'New Laptop',
      currentAmount: 60000,
      targetAmount: 60000,
      currencyCode: 'EGP',
      iconKey: 'laptop',
    ),
  ];

  /// What the empty state's button does.
  ///
  /// There is no create-goal screen — CRUD is forbidden — so it acknowledges the
  /// tap with the `comingSoon` key that already exists in both ARB files rather
  /// than swallowing it. That snackbar is the only correctly localized string here.
  void _onCreateGoal(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.comingSoon),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<FinancialGoal> goals = _mockGoals;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double gutter = AppSpacing.screenGutter(constraints.maxWidth);

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    gutter,
                    AppSpacing.md,
                    gutter,
                    AppSpacing.x2l,
                  ),
                  children: <Widget>[
                    const _GoalsHeader(
                      title: GoalsCopy.title,
                      subtitle: GoalsCopy.subtitle,
                    ),
                    AppSpacing.gapV20,

                    if (goals.isEmpty)
                      EmptyGoals(
                        title: GoalsCopy.emptyTitle,
                        description: GoalsCopy.emptyDescription,
                        actionLabel: GoalsCopy.emptyAction,
                        onCreateGoal: () => _onCreateGoal(context),
                      )
                    else ...<Widget>[
                      GoalSummary(
                        goals: goals,
                        totalLabel: GoalsCopy.totalGoals,
                        completedLabel: GoalsCopy.completedGoals,
                        averageLabel: GoalsCopy.averageProgress,
                      ),
                      AppSpacing.gapV24,
                      GoalsList(goals: goals),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A quiet subtitle above a title.
///
/// ⚠️ **Fifth copy.** `DashboardHeader`, `_AccountsHeader`, `_TransactionsHeader`,
/// `_AssetsHeader`, and now this. It belongs in
/// `lib\src\shared\widgets\page_header.dart`; that folder is still unauthorised,
/// and the four existing copies live in features this task may not modify. Flagged,
/// not fixed — TASK_018_REPORT.md.
class _GoalsHeader extends StatelessWidget {
  const _GoalsHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.gapV4,
        Text(title, style: theme.textTheme.headlineSmall),
      ],
    );
  }
}
