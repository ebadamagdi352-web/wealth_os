import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/accounts/models/account_summary.dart';
import 'package:wealth_os/src/features/accounts/widgets/accounts_list.dart';
import 'package:wealth_os/src/features/accounts/widgets/empty_accounts.dart';
import 'package:wealth_os/src/localization/generated/app_localizations.dart';

/// Every string the accounts screen renders.
///
/// Same confession as `DashboardCopy`, for the same reason: the ARB files hold
/// four keys, none of them these, and the localization layer has been out of
/// scope for six consecutive tasks. Keeping the strings in one class per feature
/// means the eventual migration is one file and one deletion, with the compiler
/// pointing at every call site.
///
/// The distinction that matters when that happens:
///
/// * **This class is UI chrome.** It must become ARB keys.
/// * **Account names are data.** "Main Bank", "Cash Wallet" — the user typed
///   those, in their own language, and they must *never* be translated. Running
///   user data through a translation layer is how an app renames someone's bank.
abstract final class AccountsCopy {
  static const String subtitle = 'Where your money lives';
  static const String title = 'Accounts';

  static const String emptyTitle = 'No accounts yet';
  static const String emptyDescription =
      'Add your first account to start tracking balances, spending and net '
      'worth in one place.';
  static const String emptyAction = 'Add account';
}

/// The accounts screen.
///
/// Presentation only. No repository, no provider, no persistence, no network, no
/// CRUD. The four accounts below are constants in this file, passed down as
/// parameters — every widget beneath is a pure function of its arguments, which
/// is what will let them be reused unchanged when the data becomes real.
class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  /// Widest the content is allowed to get. Matches the dashboard, so the two
  /// screens do not disagree about how wide a page is.
  static const double _maxContentWidth = 720;

  // ---------------------------------------------------------------------
  // MOCK DATA
  //
  // Note the currencies: **EGP and USD, side by side**. That is deliberate and
  // it is the reason this screen shows no grand total. See TASK_014_REPORT.md.
  //
  // The credit card's currency was not specified in the brief. EGP is assumed,
  // matching the other Egyptian accounts. Flagged rather than silently chosen.
  // ---------------------------------------------------------------------
  static const List<AccountSummary> _mockAccounts = <AccountSummary>[
    DepositAccount(
      id: 'acc_main_bank',
      name: 'Main Bank',
      type: AccountType.checking,
      currencyCode: 'EGP',
      balance: 520000,
    ),
    DepositAccount(
      id: 'acc_cash_wallet',
      name: 'Cash Wallet',
      type: AccountType.cash,
      currencyCode: 'EGP',
      balance: 12500,
    ),
    DepositAccount(
      id: 'acc_savings',
      name: 'Savings',
      type: AccountType.savings,
      currencyCode: 'USD',
      balance: 8400,
    ),
    CreditCardAccount(
      id: 'acc_visa_platinum',
      name: 'Visa Platinum',
      currencyCode: 'EGP',
      creditLimit: 150000,
      usedAmount: 18500,
    ),
  ];

  /// What the empty state's button does.
  ///
  /// There is no "add account" screen — this task forbids CRUD — so the button
  /// cannot create anything. It does **not** silently do nothing: a control that
  /// swallows a tap teaches a user the app is broken. It acknowledges the tap
  /// with the one honest thing available, using the `comingSoon` key that already
  /// exists in both ARB files.
  ///
  /// This is the only string on the screen that *is* correctly localized, which
  /// is a decent illustration of what the other twelve are missing.
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
  Widget build(BuildContext context) {
    const List<AccountSummary> accounts = _mockAccounts;

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

                    // The page owns the empty/non-empty decision, not the list.
                    // A list widget that renders an empty state is a list widget
                    // that has two jobs.
                    if (accounts.isEmpty)
                      EmptyAccounts(
                        title: AccountsCopy.emptyTitle,
                        description: AccountsCopy.emptyDescription,
                        actionLabel: AccountsCopy.emptyAction,
                        onAddAccount: () => _onAddAccount(context),
                      )
                    else
                      const AccountsList(accounts: accounts),
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
/// ⚠️ This is `DashboardHeader` with different strings. Two features now carry
/// the same fifteen lines, and a third will make it a pattern rather than an
/// accident.
///
/// I could not extract it: `dashboard\` is on this task's forbidden list and
/// `shared\` is not on its allowed list, so there is nowhere for a common header
/// to live. **It belongs in `lib\src\shared\widgets\page_header.dart`**, and both
/// features should import it from there. Flagged rather than quietly duplicated a
/// second time.
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
