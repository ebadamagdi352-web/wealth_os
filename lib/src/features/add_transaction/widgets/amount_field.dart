import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/add_transaction/models/transaction_form.dart';

/// The amount.
///
/// The most important control on the screen, and the one most easily got wrong.
///
/// ## Four decisions
///
/// **`TextInputType.numberWithOptions(decimal: true)`** — not `TextInputType.number`,
/// which on iOS shows a keypad with **no decimal point** and no way to type one. A
/// user entering 12.50 would be stuck.
///
/// **An input formatter, not a validator.** Non-numeric characters never reach the
/// field. Letting a user type "abc" and then telling them off is worse than not
/// letting them type it: the correction is instant and silent instead of delayed and
/// scolding. This is filtering, not validation — no rule about what the number *means*
/// is applied anywhere.
///
/// **A single leading decimal separator, at most.** The regex permits digits and one
/// dot. Without it, "1.2.3" is typeable and `double.tryParse` returns `null`, and the
/// amount silently becomes unset while the field still shows text.
///
/// **Tabular figures and a large type size.** This is the number the user is here to
/// enter; it should look like it.
class AmountField extends StatelessWidget {
  const AmountField({
    required this.controller,
    required this.currencyCode,
    required this.onChanged,
    super.key,
  });

  /// Owned by the page, so the field can be rebuilt without losing the cursor.
  final TextEditingController controller;

  /// Suffix. Follows the selected account — pick the USD savings account and this
  /// says USD, because a number without a currency is not money.
  final String currencyCode;

  /// Emits `null` when the box is empty or unparseable, never `0`. Empty and zero are
  /// different states and the form must be able to tell them apart.
  final ValueChanged<double?> onChanged;

  /// Digits, and at most one decimal point.
  static final RegExp _numeric = RegExp(r'^\d*\.?\d*$');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
        TextInputFormatter.withFunction(
          (TextEditingValue oldValue, TextEditingValue newValue) {
            if (newValue.text.isEmpty) {
              return newValue;
            }
            return _numeric.hasMatch(newValue.text) ? newValue : oldValue;
          },
        ),
      ],
      style: theme.textTheme.headlineSmall?.copyWith(
        fontFeatures: AppTypography.tabularFigures,
      ),
      decoration: AddTransactionFieldStyle.build(
        context,
        labelText: AmountFieldCopy.label,
        hintText: AmountFieldCopy.hint,
        suffixText: currencyCode,
      ),
      onChanged: (String raw) {
        final String trimmed = raw.trim();
        onChanged(trimmed.isEmpty ? null : double.tryParse(trimmed));
      },
    );
  }
}

/// Copy owned by the amount field. Not localized — see `AddTransactionCopy`.
abstract final class AmountFieldCopy {
  static const String label = 'Amount';
  static const String hint = '0';
}
