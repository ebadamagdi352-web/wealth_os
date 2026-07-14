import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// The assets empty state.
///
/// # ⚠️ Fifth copy of one widget
///
/// This is the empty-state pattern again: `EmptyStateView`/`EmptyAccounts`
/// (Task 014), `EmptyTransactions` (Task 015), and now this. The shape has not
/// changed once — icon, title, description, one required action — and it has been
/// retyped every time because `lib\src\shared\widgets\` is still not an authorised
/// location.
///
/// I will not re-argue it at length; the case is in TASK_015_REPORT.md §7. The
/// short of it: extracting is forbidden (`shared\` not allowed), importing another
/// feature's copy is worse than duplicating (it couples two features through a
/// widget), so I duplicate — visibly, deletably. **One shared file collapses five
/// copies into one**, and goals and reports will otherwise make it seven.
///
/// No illustration, consistent with the rest of the app: an illustrated empty
/// state is charming once and patronising by the third viewing. A user with no
/// assets wants the button, not a picture.
class EmptyAssets extends StatelessWidget {
  const EmptyAssets({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAddAsset,
    super.key,
  });

  final String title;
  final String description;
  final String actionLabel;

  /// Required and non-nullable. An empty state whose button does nothing is a dead
  /// end that *looks* like a way out — worse than no empty state at all.
  final VoidCallback onAddAsset;

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
                  Icons.pie_chart_outline,
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
                onPressed: onAddAsset,
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
