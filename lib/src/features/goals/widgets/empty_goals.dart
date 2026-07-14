import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// The goals empty state.
///
/// # ⚠️ Sixth copy of one widget
///
/// The empty-state pattern again — `EmptyStateView`/`EmptyAccounts` (Task 014),
/// `EmptyTransactions` (Task 015), `EmptyAssets` (Task 017), and now this. Icon,
/// title, description, one required action; the shape has not changed once, and it
/// has been retyped each time because `lib\src\shared\widgets\` is still not an
/// authorised location.
///
/// The task even asks for this to be a *"reusable widget"* — and it is, at the
/// feature level. It cannot be reused *across* features without the shared folder,
/// so "reusable" currently means "reused by copy". **One shared file collapses six
/// copies into one.** The case is in TASK_015_REPORT.md §7; I keep the flag short
/// now because it has been made four times.
class EmptyGoals extends StatelessWidget {
  const EmptyGoals({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onCreateGoal,
    super.key,
  });

  final String title;
  final String description;
  final String actionLabel;

  /// Required and non-nullable. An empty state whose button does nothing is a dead
  /// end wearing the costume of a way forward — worse than no empty state at all.
  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: AppRadius.borderCard,
                ),
                child: Icon(
                  Icons.flag_outlined,
                  size: 28,
                  color: colors.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapV20,
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              AppSpacing.gapV8,
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapV24,
              FilledButton.icon(
                onPressed: onCreateGoal,
                icon: const Icon(Icons.add, size: 18),
                label: Text(actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
