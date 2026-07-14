import 'package:wealth_os/src/routing/app_route.dart';
import 'package:wealth_os/src/routing/route_names.dart';
import 'package:wealth_os/src/routing/route_paths.dart';

/// The single source of truth for every route in the application.
///
/// A [RouteName] and a [RoutePaths] path are married here, exactly once. Nothing
/// else in the codebase pairs them — which is what makes it impossible for a
/// route's name and path to drift apart, because there is only one place they
/// could drift.
///
/// Contains no `GoRouter`, no `Navigator`, no widgets. It is a table of facts.
/// Turning that table into a router is a different job, done in a different
/// layer, in a later task.
abstract final class RouteRegistry {
  /// Every route, in declaration order.
  ///
  /// `const`, so the whole table is built at compile time.
  static const List<AppRoute> allRoutes = <AppRoute>[
    AppRoute(
      name: RouteName.home,
      path: RoutePaths.home,
      titleKey: 'navHome',
      iconKey: 'home',
    ),
    AppRoute(
      name: RouteName.dashboard,
      path: RoutePaths.dashboard,
      titleKey: 'navDashboard',
      iconKey: 'dashboard',
      showInNavigation: true,
    ),
    AppRoute(
      name: RouteName.accounts,
      path: RoutePaths.accounts,
      titleKey: 'navAccounts',
      iconKey: 'account_balance',
      showInNavigation: true,
    ),
    AppRoute(
      name: RouteName.transactions,
      path: RoutePaths.transactions,
      titleKey: 'navTransactions',
      iconKey: 'swap_horiz',
      showInNavigation: true,
    ),
    AppRoute(
      name: RouteName.assets,
      path: RoutePaths.assets,
      titleKey: 'navAssets',
      iconKey: 'diamond',
      showInNavigation: true,
    ),
    AppRoute(
      name: RouteName.goals,
      path: RoutePaths.goals,
      titleKey: 'navGoals',
      iconKey: 'flag',
      showInNavigation: true,
    ),
    AppRoute(
      name: RouteName.reports,
      path: RoutePaths.reports,
      titleKey: 'navReports',
      iconKey: 'bar_chart',
      showInNavigation: true,
    ),
    AppRoute(
      name: RouteName.settings,
      path: RoutePaths.settings,
      titleKey: 'navSettings',
      iconKey: 'settings',
      showInNavigation: true,
    ),
  ];

  /// Routes flagged for display in a navigation surface, in declaration order.
  static List<AppRoute> get navigationRoutes => allRoutes
      .where((AppRoute route) => route.showInNavigation)
      .toList(growable: false);

  /// Routes that will require a signed-in user once authentication exists.
  ///
  /// Currently empty, and honestly so — see [AppRoute.requiresAuthentication].
  static List<AppRoute> get protectedRoutes => allRoutes
      .where((AppRoute route) => route.requiresAuthentication)
      .toList(growable: false);

  // ---------------------------------------------------------------------
  // Lookup
  // ---------------------------------------------------------------------

  /// The route for [name].
  ///
  /// **Never null.** A [RouteName] originates in our own source code, so a name
  /// with no route is a programming error, not a user's mistake — and returning
  /// `null` would force every call site to handle a case that cannot legitimately
  /// happen, which is how `!` gets sprinkled through a codebase.
  ///
  /// Throws [StateError] if the table is incomplete, which [validate] guarantees
  /// it is not.
  static AppRoute findByName(RouteName name) {
    final AppRoute? route = _byName[name];
    if (route == null) {
      throw StateError(
        'No route is registered for RouteName.${name.name}. '
        'Every RouteName must have exactly one AppRoute in allRoutes.',
      );
    }
    return route;
  }

  /// The route at [path], or `null` if no route matches.
  ///
  /// **Nullable, and deliberately asymmetric with [findByName].** A path arrives
  /// from *outside* the program — a deep link, a push notification payload, a
  /// pasted URL, a typo in an address bar. An unknown path is therefore an
  /// entirely ordinary event and must be a value the caller handles, not an
  /// exception. A name comes from inside the program; a path comes from the
  /// world.
  ///
  /// Matching is exact. There are no parameterised routes yet; when there are
  /// (`/accounts/:id`), pattern matching belongs to the router, not to this
  /// table, and this method will not attempt to grow into one.
  static AppRoute? findByPath(String path) => _byPath[path];

  // ---------------------------------------------------------------------
  // Integrity
  // ---------------------------------------------------------------------

  /// Verifies the route table's invariants. Throws [StateError] on any breach.
  ///
  /// Checks that:
  ///
  /// * every [RouteName] has a route — no name is unreachable;
  /// * no name appears twice;
  /// * no path appears twice;
  /// * every path is absolute and non-empty.
  ///
  /// These cannot be enforced by the constructor, because `AppRoute` is `const`
  /// and a `const` assert must be a constant expression — `path.startsWith('/')`
  /// is a method call and is not one. So the check runs against the whole table
  /// instead, which is the right granularity anyway: "no duplicate paths" is a
  /// property no individual route can know about.
  ///
  /// Call once at startup, and in a unit test. The unit test is the one that
  /// matters — it turns a class of runtime routing bug into a build failure.
  static void validate() {
    final Set<RouteName> seenNames = <RouteName>{};
    final Set<String> seenPaths = <String>{};

    for (final AppRoute route in allRoutes) {
      if (!seenNames.add(route.name)) {
        throw StateError(
          'Duplicate route name: RouteName.${route.name.name} is declared more '
          'than once in RouteRegistry.allRoutes.',
        );
      }

      if (!seenPaths.add(route.path)) {
        throw StateError(
          'Duplicate route path: "${route.path}" is declared more than once in '
          'RouteRegistry.allRoutes.',
        );
      }

      if (route.path.isEmpty || !route.path.startsWith('/')) {
        throw StateError(
          'Invalid route path "${route.path}" for RouteName.${route.name.name}. '
          'Paths must be absolute and begin with "/".',
        );
      }
    }

    for (final RouteName name in RouteName.values) {
      if (!seenNames.contains(name)) {
        throw StateError(
          'RouteName.${name.name} has no route in RouteRegistry.allRoutes. '
          'Every name must be reachable.',
        );
      }
    }
  }

  // ---------------------------------------------------------------------
  // Indexes
  //
  // Lazy, so the cost is paid once on first lookup rather than at import.
  // Linear scans would be perfectly fast at eight routes; maps are used because
  // the table will grow, and a linear scan that becomes a hot path is a problem
  // that arrives quietly.
  // ---------------------------------------------------------------------

  static final Map<RouteName, AppRoute> _byName = <RouteName, AppRoute>{
    for (final AppRoute route in allRoutes) route.name: route,
  };

  static final Map<String, AppRoute> _byPath = <String, AppRoute>{
    for (final AppRoute route in allRoutes) route.path: route,
  };
}
