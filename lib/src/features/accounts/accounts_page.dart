import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth_os/src/core/database/app_database.dart' show Account;
import 'package:wealth_os/src/core/database/enums.dart' as db;
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/accounts/models/account_summary.dart';
import 'package:wealth_os/src/features/accounts/providers/accounts_providers.dart';
import 'package:wealth_os/src/features/accounts/widgets/accounts_list.dart';
import 'package:wealth_os/src/features/accounts/widgets/empty_accounts.dart';
import 'package:wealth_os/src/localization/generated/app_localizations.dart';

/// Every string the accounts screen renders.
///
/// Same confession as before: the ARB files hold four keys, none of them these,
/// and localization has been out of scope throughout. Account *names* are data and
/// must never be translated; this chrome must eventually become ARB keys.
abstract final class AccountsCopy {
  static const String subtitle = 'Where your money lives';
  static const String title = 'Accounts';

  static const String emptyTitle = 'No accounts yet';
  static const String emptyDescription =
      'Add your first account to start tracking balances, spending and net '
      'worth in one place.';
  static const String emptyAction = 'Add account';

  static const String errorTitle = 'Couldn\'t load your accounts';
  static const String errorDescription =
      'Something went wrong reading your accounts. Please try again.';
  static const String retry = 'Try again';
}

/// The accounts screen — now reading **live data** from the database.
///
/// This is the read-only integration: the mock list is gone, and the screen
/// watches [accountsStreamProvider], which emits the rows in the SQLite `accounts`
/// table and re-emits whenever they change. Nothing here writes, filters, sorts,
/// or validates — those are still forbidden. It resolves the four `AsyncValue`
/// states (loading, error, empty, data) and maps each database row to the
/// [AccountSummary] the existing widgets already know how to draw.
///
/// ## ⚠️ It needs a `ProviderScope` above it to run
///
/// A `ConsumerWidget` calling `ref.watch` throws *"No ProviderScope found"* unless
/// a `ProviderScope` sits above the app. The app still has none (flagged since the
/// early sprints), and that fix lives in `bootstrap.dart`, which this task may not
/// touch. So this compiles and passes the gates — none of which render this screen
/// — but opening the Accounts tab will crash until one line, `ProviderScope(child:
/// ...)`, is added at the app root. See TASK_020D_REPORT.md.
class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  /// Widest the content is allowed to get. Matches the dashboard, so the two
  /// screens do not disagree about how wide a page is.
  static const double _maxContentWidth = 720;

  /// What the empty state's button does.
  ///
  /// There is no "add account" screen yet — this task is read-only — so the button
  /// cannot create anything. It acknowledges the tap with the `comingSoon` key that
  /// already exists in both ARB files rather than swallowing it silently.
  void _onAddAccount(BuildContext context) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Account>> accountsAsync =
        ref.watch(accountsStreamProvider);

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
                    const _AccountsHeader(
                      title: AccountsCopy.title,
                      subtitle: AccountsCopy.subtitle,
                    ),
                    AppSpacing.gapV20,

                    // The four states of the stream. The page owns this decision,
                    // not the list — a list widget that renders its own loading and
                    // empty states is a list widget with three jobs.
                    accountsAsync.when(
                      loading: () => const _AccountsLoading(),
                      error: (Object error, StackTrace _) => _AccountsError(
                        onRetry: () => ref.invalidate(accountsStreamProvider),
                      ),
                      data: (List<Account> rows) => rows.isEmpty
                          ? EmptyAccounts(
                              title: AccountsCopy.emptyTitle,
                              description: AccountsCopy.emptyDescription,
                              actionLabel: AccountsCopy.emptyAction,
                              onAddAccount: () => _onAddAccount(context),
                            )
                          : AccountsList(
                              accounts: rows.map(_toSummary).toList(),
                            ),
                    ),
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

/// Maps a database [Account] row to the [AccountSummary] the widgets render.
///
/// ## Everything becomes a `DepositAccount` — and that is forced, not chosen
///
/// The sealed model has two shapes: a [DepositAccount] (a balance) and a
/// [CreditCardAccount] (a limit and a used amount). The `accounts` table stores
/// **only** `currentBalance` — it has no `creditLimit` or `usedAmount` columns — so
/// a credit-card row simply has nothing to fill a [CreditCardAccount] with. Until
/// those columns exist, every account, cards included, maps to a [DepositAccount]
/// showing its `currentBalance`. Flagged in TASK_020D_REPORT.md.
AccountSummary _toSummary(Account row) {
  return DepositAccount(
    id: row.id,
    name: row.name,
    type: _uiAccountType(row.type),
    // ⚠️ The row carries a `currencyId` (a UUID), not an ISO code. Resolving it to
    // "EGP" needs the currencies table, and this task may not add a currencies
    // source, so the id passes through as a placeholder. It is not user-visible yet
    // — the database is empty, so the empty state shows — but this is the first
    // thing the follow-up currency task must fix. See the report.
    currencyCode: row.currencyId,
    // ⚠️ `currentBalance` is integer minor units; the real scale is
    // 10^currency.decimalDigits, which again needs the currencies table. Assuming 2
    // digits here (÷100) until that lookup exists. See the report.
    balance: row.currentBalance / 100.0,
  );
}

/// Maps the database account type to the UI's four display types.
///
/// Lossy on purpose — the database has seven kinds and the UI model has four — but
/// the target only drives an icon and a label, so the near-matches are harmless.
AccountType _uiAccountType(db.AccountType type) {
  return switch (type) {
    db.AccountType.cash => AccountType.cash,
    db.AccountType.wallet => AccountType.cash,
    db.AccountType.bank => AccountType.checking,
    db.AccountType.loan => AccountType.checking,
    db.AccountType.other => AccountType.checking,
    db.AccountType.investment => AccountType.savings,
    db.AccountType.creditCard => AccountType.creditCard,
  };
}

/// The loading state: a centered spinner, sized to sit under the header rather than
/// fill the viewport, since it lives inside the page's scroll view.
class _AccountsLoading extends StatelessWidget {
  const _AccountsLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.x4l),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

/// The error state: a friendly message and a retry.
///
/// Deliberately not `EmptyStateView`, whose button bakes in an "add" (+) icon —
/// wrong for a retry. This mirrors that widget's visual language (the same tinted
/// tile, spacing, and filled button) so the two read as one family, but with an
/// error icon and a refresh action. If a third state ever needs this shape, it is
/// worth giving `EmptyStateView` an optional icon and folding these together.
class _AccountsError extends StatelessWidget {
  const _AccountsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: AppRadius.borderCard,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 28,
                  color: colors.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapV20,
              Text(
                AccountsCopy.errorTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              AppSpacing.gapV8,
              Text(
                AccountsCopy.errorDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapV24,
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text(AccountsCopy.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A quiet subtitle above a title.
///
/// ⚠️ Still the shared page-header duplication flagged since Task 014 — it belongs
/// in `lib\src\shared\widgets\page_header.dart`. Unchanged by this task.
class _AccountsHeader extends StatelessWidget {
  const _AccountsHeader({required this.title, required this.subtitle});

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
