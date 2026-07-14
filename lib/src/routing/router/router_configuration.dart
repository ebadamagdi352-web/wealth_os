import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealth_os/src/core/constants/app_constants.dart';
import 'package:wealth_os/src/core/environment/app_environment.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/features/accounts/accounts_page.dart';
import 'package:wealth_os/src/features/add_transaction/add_transaction_page.dart';
import 'package:wealth_os/src/features/assets/assets_page.dart';
import 'package:wealth_os/src/features/dashboard/dashboard_page.dart';
import 'package:wealth_os/src/features/transactions/transactions_page.dart';
import 'package:wealth_os/src/localization/generated/app_localizations.dart';
import 'package:wealth_os/src/navigation/navigation_destination.dart';
import 'package:wealth_os/src/navigation/navigation_shell.dart';
import 'package:wealth_os/src/routing/app_route.dart';
import 'package:wealth_os/src/routing/route_names.dart';
import 'package:wealth_os/src/routing/route_paths.dart';
import 'package:wealth_os/src/routing/route_registry.dart';

/// Builds the application's [GoRouter] from [RouteRegistry].
///
/// An adapter. It reads the route table; the route table has never heard of
/// GoRouter.
abstract final class RouterConfiguration {
  /// Creates the router. Called once, by `AppRouter`.
  static GoRouter create() {
    // GoRouter accepts duplicate paths silently, with the second declaration
    // shadowing the first — a bug that surfaces as one screen inexplicably
    // rendering another's content, with no error reported anywhere.
    RouteRegistry.validate();

    return GoRouter(
      initialLocation: RoutePaths.home,
      debugLogDiagnostics: AppEnvironmentConfig.current.isPreProduction,
      routes: <RouteBase>[
        // `/` redirects into the shell. It cannot simply *render* a screen: `/`
        // lives outside StatefulShellRoute, so a widget built here would appear
        // with no navigation bar and the user would have no way to reach anything
        // else.
        GoRoute(
          path: RoutePaths.home,
          name: RouteName.home.name,
          redirect: (BuildContext context, GoRouterState state) =>
              RoutePaths.dashboard,
        ),

        // =================================================================
        // ⚠️ REGISTRY VIOLATION — from Task 016, still unresolved
        // =================================================================
        //
        // `/add-transaction` is declared here with a path literal instead of in
        // RouteRegistry, because the three lines that would register it live in
        // `routing\` files this task also may not touch. The full account is in
        // TASK_016_REPORT.md §3. Nothing about Task 017 changed this; it is carried
        // forward verbatim so the add-transaction screen keeps working.
        //
        // What it still costs: `RouteRegistry.validate()` cannot see this path, so
        // the duplicate-path check has a hole; and `findByPath('/add-transaction')`
        // returns null, so a future auth guard would treat a ledger-writing form as
        // unprotected. Authorize the three routing lines and this block is deleted.
        GoRoute(
          path: '/add-transaction',
          name: 'addTransaction',
          builder: (BuildContext context, GoRouterState state) =>
              _themed(context, const AddTransactionPage()),
        ),
        // =================================================================

        // Any other route outside the shell. `home` is excluded because it is
        // declared above with a redirect rather than a builder.
        for (final AppRoute route in RouteRegistry.allRoutes)
          if (!route.showInNavigation && route.name != RouteName.home)
            GoRoute(
              name: route.nameValue,
              path: route.path,
              builder: (BuildContext context, GoRouterState state) =>
                  _themed(context, _screenFor(route)),
            ),

        // Routes inside the shell.
        //
        // `indexedStack` gives each branch its own Navigator and keeps all of them
        // alive — which preserves a tab's scroll position and its half-filled form
        // when the user switches away and back.
        StatefulShellRoute.indexedStack(
          builder: (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            // GoRouter's type is unwrapped here, not inside NavigationShell. The
            // shell takes a widget, an index and a callback — three plain values —
            // so it can be pumped in a test with no router at all.
            return _themed(
              context,
              NavigationShell(
                currentIndex: navigationShell.currentIndex,
                onDestinationSelected: (int index) {
                  navigationShell.goBranch(
                    index,
                    // Tapping the branch you are already on returns it to its root
                    // rather than doing nothing.
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                child: navigationShell,
              ),
            );
          },
          branches: <StatefulShellBranch>[
            for (final AppRoute route in RouteRegistry.navigationRoutes)
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    name: route.nameValue,
                    path: route.path,
                    builder: (BuildContext context, GoRouterState state) =>
                        _screenFor(route),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  /// Maps a registry route to the widget that renders it.
  ///
  /// Exhaustive over [RouteName]. Adding a route without giving it a screen will
  /// not compile — which is why `RouteName` was made an enum in Task 009, and the
  /// reason wiring a new feature is a one-line change here.
  ///
  /// Four of the eight routes now have real screens. Four remain.
  static Widget _screenFor(AppRoute route) {
    return switch (route.name) {
      RouteName.home => const AppPlaceholderScreen(),
      RouteName.dashboard => const DashboardPage(),
      RouteName.accounts => const AccountsPage(),
      RouteName.transactions => const TransactionsPage(),
      RouteName.assets => const AssetsPage(),
      RouteName.goals ||
      RouteName.reports ||
      RouteName.settings =>
        ComingSoonPage(route: route),
    };
  }

  // ---------------------------------------------------------------------
  // ⚠️ TEMPORARY THEME BRIDGE — delete when app.dart wires the theme
  // ---------------------------------------------------------------------

  static final ThemeData _lightTheme = AppTheme.light();
  static final ThemeData _darkTheme = AppTheme.dark();

  /// Applies the design system to a subtree.
  ///
  /// **This does not belong here.** The theme belongs on `MaterialApp`:
  ///
  /// ```dart
  /// MaterialApp.router(
  ///   theme: AppTheme.light(),
  ///   darkTheme: AppTheme.dark(),
  ///   themeMode: ThemeMode.system,
  /// )
  /// ```
  ///
  /// Three lines in `app.dart`, which has not been on a modify list since Task 010.
  /// Without something, `Theme.of(context)` returns Flutter's stock purple defaults
  /// and the design system sits unused on disk while the app renders in the wrong
  /// colours.
  ///
  /// Two costs, both real:
  ///
  /// * It reads `platformBrightness` directly, so it cannot honour a user's explicit
  ///   light/dark choice. `settingsProvider.themeMode` exists and is unreachable,
  ///   because `bootstrap.dart` still has no `ProviderScope`.
  /// * Anything rendered *above* the router — a dialog, an overlay, a date picker's
  ///   own surfaces — falls outside this `Theme`.
  static Widget _themed(BuildContext context, Widget child) {
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);
    return Theme(
      data: brightness == Brightness.dark ? _darkTheme : _lightTheme,
      child: child,
    );
  }
}

/// The former root surface.
///
/// **No longer reachable.** `/` redirects to `/dashboard`, so nothing builds it.
/// Retained because `app.dart` re-exports it and `test\widget_test.dart` imports it;
/// deleting the class would turn a failing assertion into a compile error and take
/// `flutter analyze` down with it.
class AppPlaceholderScreen extends StatelessWidget {
  const AppPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(AppConstants.appName),
      ),
    );
  }
}

/// The temporary surface shown for destinations that have no screen yet.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({required this.route, super.key});

  /// The route this page is standing in for.
  final AppRoute route;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        // Shares one derivation with the navigation bar's labels, so a route's title
        // cannot read one way in the app bar and another below it.
        title: Text(temporaryRouteTitle(route.name)),
      ),
      body: Center(
        child: Text(l10n.comingSoon),
      ),
    );
  }
}
