import 'package:flutter/material.dart';
import 'package:wealth_os/src/features/add_transaction/models/transaction_form.dart';

/// Free-text notes.
///
/// **Optional, and it says so.** The label reads "Notes (optional)" rather than leaving
/// the user to infer it from the absence of an asterisk. On a form of six fields where
/// five are required, the one that is not should announce itself — otherwise it reads as
/// another obstacle between the user and the save button.
///
/// `minLines: 3`, `maxLines: 5`. It starts tall enough to invite a sentence and grows to
/// a paragraph, then scrolls. A single-line box says "keep it short"; an unbounded one
/// pushes the save button off the screen.
///
/// `textCapitalization: sentences` — this is prose, not a code.
class NotesField extends StatelessWidget {
  const NotesField({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  /// Owned by the page, so the field can be rebuilt without losing the cursor.
  final TextEditingController controller;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextField(
      controller: controller,
      minLines: 3,
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      style: theme.textTheme.bodyLarge,
      decoration: AddTransactionFieldStyle.build(
        context,
        labelText: NotesFieldCopy.label,
        hintText: NotesFieldCopy.hint,
      ),
      onChanged: onChanged,
    );
  }
}

/// Copy owned by the notes field. Not localized — see `AddTransactionCopy`.
abstract final class NotesFieldCopy {
  static const String label = 'Notes (optional)';
  static const String hint = 'What was this for?';
}
