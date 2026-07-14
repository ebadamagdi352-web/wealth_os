import 'package:flutter/material.dart';
import 'package:wealth_os/src/features/transactions/models/transaction_summary.dart';

/// Income / Expense / Transfer.
///
/// A `SegmentedButton`, not a dropdown. Three mutually exclusive options that the
/// user changes constantly should all be visible and one tap away — a dropdown
/// would hide two of them behind a menu to save forty pixels, and cost a tap on
/// every single entry.
///
/// This control also decides the shape of the rest of the form: choosing *Transfer*
/// reveals a destination account, because a transfer with one account is not a
/// transfer.
class TransactionTypeSelector extends StatelessWidget {
  const TransactionTypeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final TransactionKind selected;
  final ValueChanged<TransactionKind> onChanged;

  /// Labels are **not localized** — the ARB files hold four keys and none are these.
  /// Eight tasks running. See `AddTransactionCopy`.
  static const Map<TransactionKind, String> _labels = <TransactionKind, String>{
    TransactionKind.income: 'Income',
    TransactionKind.expense: 'Expense',
    TransactionKind.transfer: 'Transfer',
  };

  static const Map<TransactionKind, IconData> _icons =
      <TransactionKind, IconData>{
    TransactionKind.income: Icons.south_west,
    TransactionKind.expense: Icons.north_east,
    TransactionKind.transfer: Icons.swap_horiz,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<TransactionKind>(
        segments: <ButtonSegment<TransactionKind>>[
          for (final TransactionKind kind in TransactionKind.values)
            ButtonSegment<TransactionKind>(
              value: kind,
              // The label is never hidden, even on a small phone. An icon-only
              // segmented control asking "income or expense?" is a control that gets
              // the answer wrong, and getting it wrong here means a number lands on
              // the wrong side of someone's ledger.
              label: Text(_labels[kind]!),
              icon: Icon(_icons[kind]),
            ),
        ],
        selected: <TransactionKind>{selected},
        showSelectedIcon: false,
        onSelectionChanged: (Set<TransactionKind> selection) {
          // `SegmentedButton` with `multiSelectionEnabled: false` always emits
          // exactly one value, so `.first` is safe.
          onChanged(selection.first);
        },
      ),
    );
  }
}
