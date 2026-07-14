import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/transactions/models/transaction_summary.dart';
import 'package:wealth_os/src/features/transactions/widgets/transaction_card.dart';

/// The transactions, laid out.
///
/// One column on a phone; two on a tablet, where a single column of full-width
/// cards would leave a wasteland on either side and force the eye much further
/// than it needs to travel.
///
/// The cards arrive **already ordered** — newest first. This widget does not sort,
/// filter, or group. Sorting is a decision about *what the data is*, and it belongs
/// with whatever produces the data, not with whatever draws it. A list widget that
/// sorts is a list widget that will one day disagree with the database about what
/// "recent" means.
///
/// Deliberately **not** a `ListView`: it sits inside the page's scroll view, and
/// nesting scrollables means pinning the inner one to a fixed height. That trade is
/// right at six transactions and wrong at six thousand — see TASK_015_REPORT.md.
class TransactionsList extends StatelessWidget {
  const TransactionsList({required this.transactions, super.key});

  /// Newest first.
  final List<TransactionSummary> transactions;

  /// Above this width, the cards go two-across.
  static const double _twoColumnBreakpoint = 640;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= _twoColumnBreakpoint;
        return isWide
            ? _TwoColumn(transactions: transactions)
            : _OneColumn(transactions: transactions);
      },
    );
  }
}

class _OneColumn extends StatelessWidget {
  const _OneColumn({required this.transactions});

  final List<TransactionSummary> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < transactions.length; i++) ...<Widget>[
          if (i > 0) AppSpacing.gapV12,
          TransactionCard(transaction: transactions[i]),
        ],
      ],
    );
  }
}

class _TwoColumn extends StatelessWidget {
  const _TwoColumn({required this.transactions});

  final List<TransactionSummary> transactions;

  @override
  Widget build(BuildContext context) {
    final List<List<TransactionSummary>> rows = <List<TransactionSummary>>[];
    for (int i = 0; i < transactions.length; i += 2) {
      final int end =
          (i + 2) > transactions.length ? transactions.length : i + 2;
      rows.add(transactions.sublist(i, end));
    }

    return Column(
      children: <Widget>[
        for (int r = 0; r < rows.length; r++) ...<Widget>[
          if (r > 0) AppSpacing.gapV12,
          IntrinsicHeight(
            // A card with a long title wraps taller than its neighbour, and a row
            // of two cards at different heights looks broken. `IntrinsicHeight`
            // equalises them. It is an expensive layout pass, affordable only
            // because the row holds two children — it would be the wrong tool for
            // a long grid.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int c = 0; c < 2; c++) ...<Widget>[
                  if (c > 0) AppSpacing.gapH12,
                  Expanded(
                    child: c < rows[r].length
                        ? TransactionCard(transaction: rows[r][c])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
