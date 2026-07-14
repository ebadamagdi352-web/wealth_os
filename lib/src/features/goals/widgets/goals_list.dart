import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/goals/models/financial_goal.dart';
import 'package:wealth_os/src/features/goals/widgets/goal_card.dart';

/// The goals, laid out.
///
/// One column on a phone; two on a tablet, where a lone column of full-width cards
/// would strand the eye in a wide empty margin.
///
/// The goals arrive **already ordered**. This widget does not sort, rank, or move
/// completed goals to the bottom — ordering is a statement about *what the data
/// is* and belongs with whatever produces it, not with whatever draws it.
///
/// Deliberately **not** a `ListView`: it sits inside the page's scroll view, and
/// nesting scrollables means pinning the inner one to a fixed height — right at six
/// goals and wrong at six hundred. See TASK_018_REPORT.md.
class GoalsList extends StatelessWidget {
  const GoalsList({required this.goals, super.key});

  final List<FinancialGoal> goals;

  /// Above this width, the cards go two-across.
  static const double _twoColumnBreakpoint = 640;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= _twoColumnBreakpoint;
        return isWide ? _TwoColumn(goals: goals) : _OneColumn(goals: goals);
      },
    );
  }
}

class _OneColumn extends StatelessWidget {
  const _OneColumn({required this.goals});

  final List<FinancialGoal> goals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < goals.length; i++) ...<Widget>[
          if (i > 0) AppSpacing.gapV12,
          GoalCard(goal: goals[i]),
        ],
      ],
    );
  }
}

class _TwoColumn extends StatelessWidget {
  const _TwoColumn({required this.goals});

  final List<FinancialGoal> goals;

  @override
  Widget build(BuildContext context) {
    final List<List<FinancialGoal>> rows = <List<FinancialGoal>>[];
    for (int i = 0; i < goals.length; i += 2) {
      final int end = (i + 2) > goals.length ? goals.length : i + 2;
      rows.add(goals.sublist(i, end));
    }

    return Column(
      children: <Widget>[
        for (int r = 0; r < rows.length; r++) ...<Widget>[
          if (r > 0) AppSpacing.gapV12,
          IntrinsicHeight(
            // A goal with a longer name, or a footer date its neighbour lacks, can
            // stand one card taller than the other, and a row of two different
            // heights looks broken. `IntrinsicHeight` equalises them — an expensive
            // pass, affordable only because the row holds two children.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int c = 0; c < 2; c++) ...<Widget>[
                  if (c > 0) AppSpacing.gapH12,
                  Expanded(
                    child: c < rows[r].length
                        ? GoalCard(goal: rows[r][c])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
