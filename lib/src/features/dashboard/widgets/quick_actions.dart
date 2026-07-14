import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// One tappable shortcut in the [QuickActions] grid.
class QuickAction extends Equatable {
  const QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;

  /// Required, and non-nullable, on purpose.
  ///
  /// An optional callback would make it easy to ship an action that renders
  /// perfectly and does nothing. Forcing every action to name a destination means
  /// a dead button cannot be created by omission — only on purpose.
  final VoidCallback onTap;

  @override
  List<Object?> get props => <Object?>[label, icon];
}

/// Shortcuts to the things people open the app to do.
///
/// ## Task 013 — the tiles reflow instead of shrinking
///
/// These were four tiles in a fixed row. On a 360dp phone that gives each tile
/// about 76dp, and "Add Transaction" cannot be set on one line in 76dp — so it
/// wrapped, and a row of tiles where half the labels are two lines tall looks
/// broken.
///
/// The fix is not a smaller font. It is fewer columns: below
/// [_twoColumnBreakpoint] the grid becomes 2×2, which roughly doubles the tile
/// width and lets every label sit on one line with room to spare.
///
/// Every label is additionally `maxLines: 1` with `softWrap: false`. The reflow
/// is what makes the labels fit; the clamp is what makes "no wrapping" a
/// guarantee rather than an expectation.
class QuickActions extends StatelessWidget {
  const QuickActions({
    required this.title,
    required this.actions,
    super.key,
  });

  final String title;
  final List<QuickAction> actions;

  /// Below this width, the grid drops from four columns to two.
  ///
  /// 420 is where four tiles stop being able to hold "Add Transaction" on one
  /// line, allowing for the page gutter and the gaps between them.
  static const double _twoColumnBreakpoint = 420;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns =
            constraints.maxWidth < _twoColumnBreakpoint ? 2 : actions.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: theme.textTheme.titleMedium),
            AppSpacing.gapV12,
            _ActionGrid(actions: actions, columns: columns),
          ],
        );
      },
    );
  }
}

/// Lays [actions] out in rows of [columns].
///
/// A hand-built grid rather than `GridView`, because `GridView` is scrollable and
/// this grid lives inside a `ListView` — nesting two scrollables means giving one
/// of them a fixed height, which defeats the point of a responsive tile.
class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.actions, required this.columns});

  final List<QuickAction> actions;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final List<List<QuickAction>> rows = <List<QuickAction>>[];
    for (int i = 0; i < actions.length; i += columns) {
      final int end = (i + columns) > actions.length ? actions.length : i + columns;
      rows.add(actions.sublist(i, end));
    }

    return Column(
      children: <Widget>[
        for (int r = 0; r < rows.length; r++) ...<Widget>[
          if (r > 0) AppSpacing.gapV12,
          Row(
            children: <Widget>[
              for (int c = 0; c < columns; c++) ...<Widget>[
                if (c > 0) AppSpacing.gapH12,
                // A trailing gap in a short final row is filled with an empty
                // Expanded rather than left to stretch the last tile. Otherwise a
                // five-item list would render one enormous tile on its own row.
                Expanded(
                  child: c < rows[r].length
                      ? _QuickActionTile(action: rows[r][c])
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final QuickAction action;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: AppRadius.borderLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: AppRadius.borderSm,
                ),
                child: Icon(
                  action.icon,
                  size: 19,
                  color: colors.onPrimaryContainer,
                ),
              ),
              AppSpacing.gapV8,
              Text(
                action.label,
                textAlign: TextAlign.center,
                // The guarantee. Reflowing to two columns is what makes the
                // labels *fit*; this is what makes wrapping impossible even if a
                // future label is longer than any of today's.
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
