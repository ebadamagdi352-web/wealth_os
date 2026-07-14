import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/add_transaction/models/transaction_form.dart';

/// Picks an account.
///
/// **One widget, used twice.** The transfer form needs a source *and* a destination,
/// and they are the same control with a different label — so [label] is a parameter,
/// and there is no `DestinationAccountSelector` anywhere in this codebase.
///
/// Each entry shows the account's currency beside its name. Without it, "Savings" and
/// "Main Bank" look interchangeable, and a user moving 5,000 into a USD account has no
/// way to notice that the number means something very different once it lands.
///
/// Built from `InputDecorator` + `DropdownButton` rather than `DropdownButtonFormField`.
/// The latter is a `FormField`: it owns its own value, and `initialValue` is applied on
/// first build only. This form's state lives in one immutable `TransactionForm`, and a
/// control that keeps a private copy of part of that state is a control that will one
/// day disagree with it. This one is fully driven by [selectedId].
class AccountSelector extends StatelessWidget {
  const AccountSelector({
    required this.label,
    required this.accounts,
    required this.selectedId,
    required this.onChanged,
    this.excludedId,
    super.key,
  });

  /// "From", "To", "Account" — the caller decides.
  final String label;

  final List<FormAccount> accounts;

  final String? selectedId;

  final ValueChanged<String?> onChanged;

  /// An account to leave out of the list.
  ///
  /// Used by the transfer form to stop the destination dropdown offering the account
  /// the money is already leaving. **A transfer from an account to itself is not a
  /// transaction, it is a no-op** — and it is far easier to make it unselectable than
  /// to explain afterwards why it was rejected.
  final String? excludedId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<FormAccount> options = excludedId == null
        ? accounts
        : accounts
            .where((FormAccount account) => account.id != excludedId)
            .toList(growable: false);

    // If the selected account is no longer among the options — the user picked the
    // same account on both sides, then changed the other one — the value is dropped.
    // Handing a `DropdownButton` a value that is not in its items throws.
    final bool selectionIsValid = selectedId != null &&
        options.any((FormAccount account) => account.id == selectedId);
    final String? value = selectionIsValid ? selectedId : null;

    return InputDecorator(
      decoration: AddTransactionFieldStyle.build(context, labelText: label),
      isEmpty: value == null,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          items: <DropdownMenuItem<String>>[
            for (final FormAccount account in options)
              DropdownMenuItem<String>(
                value: account.id,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        account.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    AppSpacing.gapH8,
                    Text(
                      account.currencyCode,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
}
