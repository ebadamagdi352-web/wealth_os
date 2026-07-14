import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/add_transaction/models/transaction_form.dart';
import 'package:wealth_os/src/features/transactions/models/transaction_summary.dart';

/// Picks a category.
///
/// The options come from `TransactionCategory` — the **same enum the transactions list
/// renders**. They are not a second list defined here.
///
/// That matters more than it looks. A form with its own copy of the categories can
/// produce a value the list cannot draw, and the compiler will not notice, because two
/// enums that happen to share names are still two types. One enum, one source of truth,
/// and adding a category updates both screens at once.
///
/// Built from `InputDecorator` + `DropdownButton` rather than `DropdownButtonFormField`,
/// for the reason given in `AccountSelector`: this form's state lives in one immutable
/// object, and a control that keeps a private copy of part of it will one day disagree
/// with it.
class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final TransactionCategory? selected;
  final ValueChanged<TransactionCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return InputDecorator(
      decoration: AddTransactionFieldStyle.build(
        context,
        labelText: CategorySelectorCopy.label,
      ),
      isEmpty: selected == null,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TransactionCategory>(
          value: selected,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          items: <DropdownMenuItem<TransactionCategory>>[
            for (final TransactionCategory category
                in TransactionCategory.values)
              DropdownMenuItem<TransactionCategory>(
                value: category,
                child: Row(
                  children: <Widget>[
                    Icon(
                      _icons[category.iconKey] ?? _fallbackIcon,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                    AppSpacing.gapH12,
                    Expanded(
                      child: Text(
                        // Not localized. Eight tasks running.
                        category.displayLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// Mirrors `TransactionIcons` in the transactions feature.
  ///
  /// ⚠️ A second copy of a key→icon map. I could import `TransactionIcons` — it is
  /// public — but that is the one dependency edge worth keeping: this feature already
  /// imports the transactions *model*, which is a domain type it must not duplicate. An
  /// icon map is presentation, and importing it would deepen a coupling I would rather
  /// keep to the narrowest possible surface.
  ///
  /// The correct home for both is a shared icon registry. Flagged in
  /// TASK_016_REPORT.md, along with the two other things waiting for `shared\`.
  static const Map<String, IconData> _icons = <String, IconData>{
    'income': Icons.payments_outlined,
    'investment': Icons.diamond_outlined,
    'utilities': Icons.bolt_outlined,
    'groceries': Icons.shopping_cart_outlined,
    'transfer': Icons.swap_horiz,
  };

  static const IconData _fallbackIcon = Icons.receipt_long_outlined;
}

/// Copy owned by the category selector. Not localized — see `AddTransactionCopy`.
abstract final class CategorySelectorCopy {
  static const String label = 'Category';
}
