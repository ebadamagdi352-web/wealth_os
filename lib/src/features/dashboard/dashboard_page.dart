import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/dashboard/widgets/asset_summary.dart';
import 'package:wealth_os/src/features/dashboard/widgets/dashboard_header.dart';
import 'package:wealth_os/src/features/dashboard/widgets/net_worth_card.dart';
import 'package:wealth_os/src/features/dashboard/widgets/quick_actions.dart';
import 'package:wealth_os/src/features/dashboard/widgets/recent_activity.dart';
import 'package:wealth_os/src/routing/route_names.dart';

/// Every string the dashboard renders.
///
/// ## Why they are all in one class, and why that is a confession
///
/// The standing rule since Task 006 is **do not hardcode strings inside widgets**.
/// This class breaks it. It breaks it in exactly one place, on purpose.
///
/// The dashboard needs roughly a dozen strings. None of them exist in
/// `app_en.arb` or `app_ar.arb`, `gen-l10n` emits a typed getter only for keys
/// that are *declared*, and the localization layer is on this task's forbidden
/// list. There is no arrangement of imports that produces a translated
/// "Total Net Worth" today.
///
/// So: rather than scatter a dozen literals across five widget files, every one
/// of them is here. Migrating to ARB then means editing **one** file and deleting
/// **one** class — a mechanical change of maybe twenty minutes, with the compiler
/// pointing at every call site.
///
/// A distinction worth keeping in view when that happens:
///
/// * The strings **in this class** are UI chrome. They must become ARB keys.
/// * The strings in [_mockAssets] and [_mockActivity] — "Gold", "Salary",
///   "Electricity" — are **data**. They will arrive from the database, entered by
///   the user in their own language, and must *never* be translated. Sending user
///   data through a translation layer is how an app renames someone's account.
abstract final class DashboardCopy {
  static const String subtitle = 'Your financial overview';
  static const String title = 'Dashboard';

  static const String netWorthLabel = 'Total Net Worth';
  static const String quickActionsTitle = 'Quick Actions';
  static const String assetsTitle = 'Assets';
  static const String recentActivityTitle = 'Recent Activity';

  static const String addTransaction = 'Add Transaction';
  static const String addAsset = 'Add Asset';
  static const String transfer = 'Transfer';
  static const String reports = 'Reports';
}

/// The dashboard.
///
/// Presentation only. No provider, no repository, no database, no network. The
/// figures below are constants declared in this file and passed down as
/// parameters — every widget on this screen is a pure function of its arguments,
/// which is what will let them be reused unchanged when the data becomes real.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  /// Widest the content is allowed to get.
  ///
  /// On a tablet or a desktop window, a dashboard stretched to 1400px is not
  /// "responsive" — it is unreadable. Lines of text get too long to scan and the
  /// eye loses its place returning to the left margin. The layout centres and
  /// stops growing instead.
  static const double _maxContentWidth = 720;

  // ---------------------------------------------------------------------
  // MOCK DATA
  //
  // Hardcoded, and confined to this file. When a repository exists, these five
  // constants are deleted and replaced by a single `ref.watch(...)` — no widget
  // below changes, because no widget below knows where its data came from.
  // ---------------------------------------------------------------------

  static const String _currencyCode = 'EGP';

  static const double _netWorth = 1245300;

  static const List<AssetHolding> _mockAssets = <AssetHolding>[
    AssetHolding(name: 'Gold', amount: 520000, icon: Icons.diamond_outlined),
    AssetHolding(name: 'Stocks', amount: 340000, icon: Icons.show_chart),
    AssetHolding(
      name: 'Cash',
      amount: 120000,
      icon: Icons.account_balance_wallet_outlined,
    ),
    AssetHolding(
      name: 'Real Estate',
      amount: 265300,
      icon: Icons.home_work_outlined,
    ),
  ];

  static const List<ActivityEntry> _mockActivity = <ActivityEntry>[
    ActivityEntry(
      title: 'Salary',
      amount: 18000,
      timeLabel: 'Today',
      icon: Icons.payments_outlined,
    ),
    ActivityEntry(
      title: 'Electricity',
      amount: -1250,
      timeLabel: 'Today',
      icon: Icons.bolt_outlined,
    ),
    ActivityEntry(
      title: 'Bought Gold',
      amount: 25000,
      timeLabel: 'Yesterday',
      icon: Icons.diamond_outlined,
    ),
  ];

  /// The four shortcuts.
  ///
  /// Each one navigates. None is a dead button — `QuickAction.onTap` is
  /// non-nullable precisely so that a shortcut cannot be shipped without a
  /// destination.
  ///
  /// Two of them are approximations, and I would rather say so than let it pass
  /// unnoticed: there is no *add* screen for a transaction or an asset yet, so
  /// those two open the relevant list. "Transfer" has no route of its own at all
  /// and opens Transactions. When the real screens exist, these four lines are
  /// where they get wired up.
  List<QuickAction> _actions(BuildContext context) {
    return <QuickAction>[
      QuickAction(
        label: DashboardCopy.addTransaction,
        icon: Icons.add_circle_outline,
        onTap: () => context.goNamed(RouteName.transactions.name),
      ),
      QuickAction(
        label: DashboardCopy.addAsset,
        icon: Icons.diamond_outlined,
        onTap: () => context.goNamed(RouteName.assets.name),
      ),
      QuickAction(
        label: DashboardCopy.transfer,
        icon: Icons.swap_horiz,
        onTap: () => context.goNamed(RouteName.transactions.name),
      ),
      QuickAction(
        label: DashboardCopy.reports,
        icon: Icons.bar_chart_outlined,
        onTap: () => context.goNamed(RouteName.reports.name),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.x2l,
              ),
              children: <Widget>[
                const DashboardHeader(
                  title: DashboardCopy.title,
                  subtitle: DashboardCopy.subtitle,
                ),
                AppSpacing.gapV24,
                const NetWorthCard(
                  label: DashboardCopy.netWorthLabel,
                  amount: _netWorth,
                  currencyCode: _currencyCode,
                ),
                AppSpacing.gapV24,
                QuickActions(
                  title: DashboardCopy.quickActionsTitle,
                  actions: _actions(context),
                ),
                AppSpacing.gapV24,
                const AssetSummary(
                  title: DashboardCopy.assetsTitle,
                  holdings: _mockAssets,
                  currencyCode: _currencyCode,
                ),
                AppSpacing.gapV24,
                const RecentActivity(
                  title: DashboardCopy.recentActivityTitle,
                  entries: _mockActivity,
                  currencyCode: _currencyCode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
