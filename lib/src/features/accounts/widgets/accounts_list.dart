import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/accounts/models/account_summary.dart';
import 'package:wealth_os/src/features/accounts/widgets/account_card.dart';

/// The accounts, laid out.
///
/// One column on a phone; two on a tablet, where a single column of full-width
/// cards would leave a wasteland of empty space on either side and force the eye
/// to travel much further than it needs to.
///
/// Deliberately **not** a `ListView` or a `GridView`. This sits inside the page's
/// scroll view, and nesting two scrollables means pinning the inner one to a
/// fixed height — which would then clip the credit card, because a credit card is
/// taller than a chequing account. A plain `Column` grows to whatever its
/// children need.
///
/// That trade is correct at four accounts and wrong at four hundred: a `Column`
/// builds every child, whereas a `ListView` builds only what is visible. When
/// accounts arrive from a database and the count is unbounded, the page's
/// `ListView` should absorb this list via `SliverList` rather than this widget
/// growing a scroll view of its own. Noted in TASK_014_REPORT.md.
class AccountsList extends StatelessWidget {
  const AccountsList({required this.accounts, super.key});

  final List<AccountSummary> accounts;

  /// Above this width, the cards go two-across.
  static const double _twoColumnBreakpoint = 640;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= _twoColumnBreakpoint;
        return isWide
            ? _TwoColumn(accounts: accounts)
            : _OneColumn(accounts: accounts);
      },
    );
  }
}

class _OneColumn extends StatelessWidget {
  const _OneColumn({required this.accounts});

  final List<AccountSummary> accounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < accounts.length; i++) ...<Widget>[
          if (i > 0) AppSpacing.gapV12,
          AccountCard(account: accounts[i]),
        ],
      ],
    );
  }
}

class _TwoColumn extends StatelessWidget {
  const _TwoColumn({required this.accounts});

  final List<AccountSummary> accounts;

  @override
  Widget build(BuildContext context) {
    final List<List<AccountSummary>> rows = <List<AccountSummary>>[];
    for (int i = 0; i < accounts.length; i += 2) {
      final int end = (i + 2) > accounts.length ? accounts.length : i + 2;
      rows.add(accounts.sublist(i, end));
    }

    return Column(
      children: <Widget>[
        for (int r = 0; r < rows.length; r++) ...<Widget>[
          if (r > 0) AppSpacing.gapV12,
          IntrinsicHeight(
            // Without this, a row holding a credit card beside a chequing account
            // renders one tall card and one short one, and the row looks broken.
            // `IntrinsicHeight` makes both cards as tall as the taller — which is
            // an expensive layout pass, and affordable here only because the row
            // holds two children. It would be the wrong tool for a long grid.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int c = 0; c < 2; c++) ...<Widget>[
                  if (c > 0) AppSpacing.gapH12,
                  Expanded(
                    child: c < rows[r].length
                        ? AccountCard(account: rows[r][c])
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
