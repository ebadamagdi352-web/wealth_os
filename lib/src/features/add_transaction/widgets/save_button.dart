import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';

/// The save button.
///
/// Full width, 52 tall, primary. It is the only filled button on the screen, and that is
/// what makes it the obvious end of the form — a page with three filled buttons has no
/// primary action, it has three competing ones.
///
/// ## Disabled until the form is fillable
///
/// [enabled] comes from `TransactionForm.isComplete`, which asks *has the user finished?*
/// — not *is this transaction legal?* There is no minimum, no maximum, no currency
/// matching, no business rule of any kind. Those are the things the task forbids and
/// none of them are here.
///
/// A save button that is enabled on an empty form is a button whose only purpose is to
/// produce an error message. Disabling it turns "you did it wrong" into "you're not done
/// yet", which is the same information delivered before the mistake instead of after.
///
/// If you read the no-validation rule more strictly than I have, passing `enabled: true`
/// removes the behaviour entirely. See TASK_016_REPORT.md.
class SaveButton extends StatelessWidget {
  const SaveButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final String label;

  final bool enabled;

  /// Required and non-nullable. Whether the button *acts* is [enabled]'s decision, not a
  /// missing callback's — a button with no `onPressed` is dead by omission, and dead by
  /// omission is the failure mode that ships.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,
          ),
          textStyle: theme.textTheme.labelLarge,
        ),
        child: Text(label),
      ),
    );
  }
}
