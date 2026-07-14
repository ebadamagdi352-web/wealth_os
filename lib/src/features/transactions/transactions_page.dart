import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/transactions/models/transaction_summary.dart';
import 'package:wealth_os/src/features/transactions/widgets/empty_transactions.dart';
import 'package:wealth_os/src/features/transactions/widgets/transactions_list.dart';
import 'package:wealth_os/src/localization/generated/app_localizations.dart';

/// Every string the transactions screen renders.
///
/// Same confession as `DashboardCopy` and `AccountsCopy`, for the same reason: the
/// ARB files hold four keys, none of them these, and localization has been out of
/// scope for seven consecutive tasks. One class per feature keeps the eventual
/// migration to one file and one deletion, with the compiler pointing at every call
/// site.
///
/// * **This class is UI chrome.** It must become ARB keys.
/// * **Transaction titles are data.** "Salary", "Supermarket" — the user typed
///   those, in their own language. They must *never* be translated.
abstract final class TransactionsCopy {
  static const String subtitle = 'Every movement, in order';
  static const String title = 'Transactions';

  static const String emptyTitle = 'No transactions yet';
  static const String emptyDescription =
      'Record your first transaction to see where your money goes and how your '
      'net worth changes over time.';
  static const String emptyAction = 'Add transaction';
}

/// The transactions screen.
///
/// Presentation only. No repository, no provider, no persistence, no network, no
/// CRUD, no business logic. The six transactions below are constants in this file,
/// passed down as parameters — every widget beneath is a pure function of its
/// arguments, which is what will let them be reused unchanged when the data becomes
/// real.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  /// Widest the content is allowed to get. Matches the dashboard and accounts, so
  /// the three screens do not disagree about how wide a page is.
  static const double _maxContentWidth = 720;

  // ---------------------------------------------------------------------
  // MOCK DATA
  //
  // `static final`, not `const`: `DateTime` cannot be `const`. The dates are
  // computed relative to today, so "Today" and "Yesterday" stay true tomorrow —
  // which a hardcoded date string would not.
  //
  // Ordered newest first. The list widget does not sort: sorting is a decision
  // about *what the data is*, and it belongs with whatever produces the data.
  // ---------------------------------------------------------------------
  static final List<TransactionSummary> _mockTransactions = _buildMock();

  static List<TransactionSummary> _buildMock() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime threeDaysAgo = today.subtract(const Duration(days: 3));

    return <TransactionSummary>[
      TransactionSummary(
        id: 'txn_salary',
        title: 'Salary',
        amount: 18000,
        currencyCode: 'EGP',
        kind: TransactionKind.income,
        category: TransactionCategory.income,
        occurredAt: today,
      ),
      TransactionSummary(
        id: 'txn_dividend',
        title: 'Dividend',
        amount: 3400,
        currencyCode: 'EGP',
        kind: TransactionKind.income,
        category: TransactionCategory.income,
        occurredAt: today,
      ),
      TransactionSummary(
        id: 'txn_electricity',
        title: 'Electricity',
        amount: -1250,
        currencyCode: 'EGP',
        kind: TransactionKind.expense,
        category: TransactionCategory.utilities,
        occurredAt: today,
      ),
      TransactionSummary(
        id: 'txn_supermarket',
        title: 'Supermarket',
        amount: -820,
        currencyCode: 'EGP',
        kind: TransactionKind.expense,
        category: TransactionCategory.groceries,
        occurredAt: yesterday,
      ),

      // Buying gold is **not** an expense. Money left the cash account, but net
      // worth did not move — it changed shape. Marking it `expense` would paint it
      // red and tell the user they lost 25,000 EGP, which is false.
      //
      // This is why `TransactionKind` exists separately from the sign of the
      // amount. See TASK_015_REPORT.md.
      TransactionSummary(
        id: 'txn_bought_gold',
        title: 'Bought Gold',
        amount: -25000,
        currencyCode: 'EGP',
        kind: TransactionKind.transfer,
        category: TransactionCategory.investment,
        occurredAt: yesterday,
      ),
      TransactionSummary(
        id: 'txn_transfer_savings',
        title: 'Transfer to Savings',
        amount: -5000,
        currencyCode: 'EGP',
        kind: TransactionKind.transfer,
        category: TransactionCategory.transfer,
        occurredAt: threeDaysAgo,
      ),
    ];
  }

  /// What the empty state's button does.
  ///
  /// There is no add-transaction screen — this task forbids CRUD — so the button
  /// cannot create anything. It does **not** silently do nothing: a control that
  /// swallows a tap teaches a user the app is broken. It acknowledges the tap with
  /// the one honest thing available, using the `comingSoon` key that already exists
  /// in both ARB files.
  ///
  /// That snackbar is the only correctly localized string on this screen.
  void _onAddTransaction(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.comingSoon),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<TransactionSummary> transactions = _mockTransactions;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double gutter = AppSpacing.screenGutter(constraints.maxWidth);

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    gutter,
                    AppSpacing.md,
                    gutter,
                    AppSpacing.x2l,
                  ),
                  children: <Widget>[
                    const _TransactionsHeader(
                      title: TransactionsCopy.title,
                      subtitle: TransactionsCopy.subtitle,
                    ),
                    AppSpacing.gapV20,

                    // The page owns the empty/non-empty decision, not the list. A
                    // list widget that renders an empty state is a list widget with
                    // two jobs.
                    if (transactions.isEmpty)
                      EmptyTransactions(
                        title: TransactionsCopy.emptyTitle,
                        description: TransactionsCopy.emptyDescription,
                        actionLabel: TransactionsCopy.emptyAction,
                        onAddTransaction: () => _onAddTransaction(context),
                      )
                    else
                      TransactionsList(transactions: transactions),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A quiet subtitle above a title.
///
/// ⚠️ **Third copy.** `DashboardHeader`, `_AccountsHeader`, and now this. Fifteen
/// identical lines in three features is no longer an accident; it is a pattern
/// that has not been named.
///
/// It belongs in `lib\src\shared\widgets\page_header.dart`. I could not put it
/// there: `shared\` is not on this task's allowed file list, and `dashboard\` and
/// `accounts\` are both forbidden to modify — so there is nowhere for a common
/// header to live and no way to make the existing two use it.
///
/// This is the second thing in this task that duplication rules could not save. See
/// TASK_015_REPORT.md.
class _TransactionsHeader extends StatelessWidget {
  const _TransactionsHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.gapV4,
        Text(title, style: theme.textTheme.headlineSmall),
      ],
    );
  }
}
