import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/features/add_transaction/models/transaction_form.dart';

/// Picks the date.
///
/// A read-only field that opens `showDatePicker`. Not a text box: a date typed by hand
/// is a date entered in whichever format the user assumed, and `03/04/2026` is two
/// different days depending on which side of the Atlantic they learned to write.
///
/// ## The future is closed
///
/// `lastDate` is **today**. A transaction that has not happened yet is not a
/// transaction — it is a plan, and a ledger that accepts plans stops being a record of
/// what occurred. Budgeting and scheduled payments are a different feature with a
/// different table; letting them in through this field would corrupt every "spent this
/// month" total the moment someone entered next month's rent.
///
/// `firstDate` is ten years back — long enough for anyone importing history, short
/// enough that a typo in the year lands outside the range and gets caught by the picker
/// rather than by a confused user.
class DateSelector extends StatelessWidget {
  const DateSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final DateTime? selected;
  final ValueChanged<DateTime> onChanged;

  static const int _yearsOfHistory = 10;

  static final DateFormat _display = DateFormat.yMMMMd('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    final String text = selected == null
        ? DateSelectorCopy.hint
        : _display.format(selected!);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: AddTransactionFieldStyle.build(
          context,
          labelText: DateSelectorCopy.label,
        ),
        isEmpty: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: selected == null
                      ? colors.onSurfaceVariant
                      : colors.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selected ?? today,
      firstDate: DateTime(today.year - _yearsOfHistory),
      lastDate: today,
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}

/// Copy owned by the date selector. Not localized — see `AddTransactionCopy`.
abstract final class DateSelectorCopy {
  static const String label = 'Date';
  static const String hint = 'Select a date';
}
