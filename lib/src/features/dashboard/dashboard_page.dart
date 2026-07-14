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
/// The standing rule since Task 006 is **do not hardcode strings inside widgets**.
/// This class breaks it, in exactly one place, on purpose.
///
/// The dashboard needs about a dozen strings. None exist in `app_en.arb` or
/// `app_ar.arb`, `gen-l10n` emits a typed getter only for keys that are
/// *declared*, and the localization layer has been out of scope for four
/// consecutive tasks. There is no arrangement of imports that produces a
/// translated "Total Net Worth" today.
///
/// So rather than scatter a dozen literals across five widget files, every one is
/// here. Migrating to ARB means editing **one** file and deleting **one** class.
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
  /// "responsive" — it is unreadable. Lines get too long to scan and the eye loses
  /// its place returning to the left margin. The layout centres and stops growing.
  static const double _maxContentWidth = 720;

  // ---------------------------------------------------------------------
  // MOCK DATA — unchanged in Task 013.
  //
  // Confined to this file. When a repository exists, these constants are deleted
  // and replaced by a single `ref.watch(...)` — no widget below changes, because
  // no widget below knows where its data came from.
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
  /// Two are approximations: there is no *add* screen for a transaction or an
  /// asset yet, so those open the relevant list, and "Transfer" has no route of
  /// its own at all. When the real screens exist, these four lines are where they
  /// get wired.
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
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // The gutter grows with the window: 16 on a small phone, 20 on a
            // large one, 24 on a tablet. A fixed 16pt gutter is correct on a
            // 360dp phone and mean on a tablet, where the content ends up pinned
            // to the edges of a very wide sheet of glass.
            final double gutter =
                AppSpacing.screenGutter(constraints.maxWidth);

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    gutter,
                    AppSpacing.md,
                    gutter,
                    // Generous bottom padding so the last card clears the
                    // navigation bar when the list is scrolled to the end.
                    AppSpacing.x2l,
                  ),
                  children: <Widget>[
                    const DashboardHeader(
                      title: DashboardCopy.title,
                      subtitle: DashboardCopy.subtitle,
                    ),
                    // The header sits closer to the hero than the sections sit to
                    // each other. Vertical rhythm is not one uniform gap — it is a
                    // hierarchy of gaps, and a label should always be nearer to
                    // the thing it labels than to whatever comes next.
                    AppSpacing.gapV16,
                    const NetWorthCard(
                      label: DashboardCopy.netWorthLabel,
                      amount: _netWorth,
                      currencyCode: _currencyCode,
                    ),
                    AppSpacing.sectionGap,
                    QuickActions(
                      title: DashboardCopy.quickActionsTitle,
                      actions: _actions(context),
                    ),
                    AppSpacing.sectionGap,
                    const AssetSummary(
                      title: DashboardCopy.assetsTitle,
                      holdings: _mockAssets,
                      currencyCode: _currencyCode,
                    ),
                    AppSpacing.gapV16,
                    const RecentActivity(
                      title: DashboardCopy.recentActivityTitle,
                      entries: _mockActivity,
                      currencyCode: _currencyCode,
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
