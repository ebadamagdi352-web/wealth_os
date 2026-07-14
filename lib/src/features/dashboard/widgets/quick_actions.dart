import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// One tappable shortcut in the [QuickActions] row.
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

/// A row of shortcuts to the things people open the app to do.
///
/// Four fixed items, spread evenly. Not a scrolling list: a horizontally
/// scrolling action row hides its own contents, and the fifth item nobody sees is
/// the fifth item nobody uses.
class QuickActions extends StatelessWidget {
  const QuickActions({
    required this.title,
    required this.actions,
    super.key,
  });

  final String title;
  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapV12,
        Row(
          children: <Widget>[
            for (int i = 0; i < actions.length; i++) ...<Widget>[
              if (i > 0) AppSpacing.gapH12,
              Expanded(child: _QuickActionTile(action: actions[i])),
            ],
          ],
        ),
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
      color: colors.surfaceContainer,
      borderRadius: AppRadius.borderMd,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                action.icon,
                size: 22,
                color: colors.primary,
              ),
              AppSpacing.gapV8,
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
