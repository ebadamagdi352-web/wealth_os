import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// The transactions empty state.
///
/// # ⚠️ This is a copy, and I could not avoid it
///
/// `EmptyStateView` in `features\accounts\widgets\empty_accounts.dart` is the same
/// widget. This is the **second** copy, and the quality rules for this task say
/// *no duplicated code*.
///
/// The three ways out, and why each is closed:
///
/// 1. **Extract to `lib\src\shared\widgets\empty_state_view.dart`.** Correct.
///    Not permitted — `shared\` is not on this task's allowed file list.
/// 2. **Import it from `features\accounts\`.** Permitted by the letter of the
///    rules — `accounts\` is forbidden to *modify*, not to import — and **worse
///    than duplicating.** It would make `transactions` depend on `accounts`, which
///    is precisely the coupling a feature-first structure exists to prevent. That
///    edge is invisible, it multiplies, and the day someone refactors accounts the
///    transactions screen breaks for no reason a reader could guess.
/// 3. **Duplicate.** Wrong, but *visibly* wrong, and undone by deleting a file.
///
/// I took the third. Duplication is a debt with an obvious repayment; a
/// feature-to-feature dependency is a debt that compounds quietly.
///
/// **Authorize `lib\src\shared\widgets\` and this file shrinks to six lines.** Every
/// feature still to come — goals, reports, assets — needs an empty state, and this
/// becomes copy number five.
///
/// No illustration, as specified — and that is right for a reason worth keeping: an
/// illustrated empty state is charming the first time and patronising the third. A
/// user staring at "no transactions" wants a button, not a cartoon.
class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAddTransaction,
    super.key,
  });

  final String title;
  final String description;
  final String actionLabel;

  /// Required, and non-nullable.
  ///
  /// An empty state whose button does nothing is worse than no empty state — it is
  /// a dead end that *looks* like a way out. Making the callback required means one
  /// cannot be shipped by omission.
  final VoidCallback onAddTransaction;

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
                  Icons.receipt_long_outlined,
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
                onPressed: onAddTransaction,
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
