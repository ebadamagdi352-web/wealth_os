import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// A generic empty state: icon, title, description, one action.
///
/// ## This belongs in `shared\`, not here
///
/// Every feature in this product will need an empty state — accounts,
/// transactions, goals, reports. Building a bespoke one per feature is how a
/// product ends up with five empty states that look like five different apps.
///
/// It lives in `features\accounts\widgets\` only because this task's file list
/// permits nothing else. **It should be moved to `lib\src\shared\widgets\` the
/// first time a second feature needs it** — and it will, immediately. Flagged in
/// TASK_014_REPORT.md rather than left to be rediscovered by whoever builds
/// transactions.
///
/// No illustration, as specified — and that is the right call for a reason worth
/// keeping: an illustrated empty state is charming the first time and
/// patronising the third. A user staring at "no accounts" wants a button, not a
/// cartoon.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;

  /// Required, and non-nullable.
  ///
  /// An empty state whose button does nothing is worse than no empty state — it
  /// is a dead end that *looks* like a way out. Making the callback required means
  /// one cannot be shipped by omission.
  final VoidCallback onAction;

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
                  icon,
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
                onPressed: onAction,
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

/// The accounts empty state.
///
/// A thin configuration of [EmptyStateView] — the icon is the only thing it
/// decides. Its copy arrives from the page, so that every string on this screen
/// still has exactly one home.
class EmptyAccounts extends StatelessWidget {
  const EmptyAccounts({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAddAccount,
    super.key,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAddAccount;

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.account_balance_outlined,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAddAccount,
    );
  }
}
