import 'package:equatable/equatable.dart';
import 'package:wealth_os/src/routing/app_route.dart';
import 'package:wealth_os/src/routing/route_names.dart';
import 'package:wealth_os/src/routing/route_registry.dart';

/// A destination in the navigation bar.
///
/// Named `AppNavigationDestination`, **not** `NavigationDestination`. Flutter's
/// Material library already exports a widget by that name, and the shell imports
/// both — two `NavigationDestination`s in one file is an ambiguous-import error,
/// not a matter of taste. The prefix is the price of the collision.
///
/// Pure Dart. No `IconData`, no `Widget`, no Flutter import anywhere. It carries
/// an [iconKey] — a string — and the shell resolves that to a concrete icon. That
/// is what keeps this model testable without a widget tree, and what allows the
/// icon set to be swapped without touching the navigation model.
///
/// Every instance is derived from an [AppRoute]. There is no constructor call
/// with hand-written arguments anywhere in the codebase — see [all].
class AppNavigationDestination extends Equatable {
  const AppNavigationDestination({
    required this.routeName,
    required this.path,
    required this.iconKey,
    required this.titleKey,
  });

  /// Projects an [AppRoute] onto the subset the navigation bar needs.
  ///
  /// Deliberately narrower than [AppRoute]: `requiresAuthentication` and
  /// `showInNavigation` are dropped, because a destination that has reached this
  /// point has already answered both questions. Handing the shell the full route
  /// would invite it to make routing decisions, which is not its job.
  factory AppNavigationDestination.fromRoute(AppRoute route) {
    return AppNavigationDestination(
      routeName: route.name,
      path: route.path,
      iconKey: route.iconKey,
      titleKey: route.titleKey,
    );
  }

  /// Every destination, in registry order.
  ///
  /// **This is the only source of navigation items.** Nothing constructs an
  /// `AppNavigationDestination` by hand, so a destination cannot appear in the
  /// bar without existing as a route, and the bar cannot fall out of step with
  /// the router — both read the same list.
  ///
  /// The order matters and is load-bearing: the shell's branch order, the bar's
  /// destination order, and this list are all the same sequence, which is what
  /// makes a tapped index unambiguously identify a route. See the note in
  /// `navigation_shell.dart`.
  static List<AppNavigationDestination> get all => RouteRegistry.navigationRoutes
      .map(AppNavigationDestination.fromRoute)
      .toList(growable: false);

  /// The route this destination opens.
  final RouteName routeName;

  /// The path this destination navigates to.
  final String path;

  /// Stable identifier for the icon. Resolved to an `IconData` by the shell.
  final String iconKey;

  /// The ARB key of this destination's label.
  final String titleKey;

  /// A human-readable label, derived from the route identifier.
  ///
  /// **Not localized.** See [temporaryRouteTitle].
  String get temporaryLabel => temporaryRouteTitle(routeName);

  @override
  List<Object?> get props => <Object?>[routeName, path, iconKey, titleKey];

  @override
  bool get stringify => true;
}

/// A human-readable title derived from a route's own identifier.
///
/// `RouteName.dashboard` → `"Dashboard"`.
///
/// ## This is not localized, and it is now visible on every screen
///
/// [AppRoute.titleKey] holds ARB keys — `navDashboard`, `navAccounts`, and six
/// more — that **do not exist** in `app_en.arb` or `app_ar.arb`. `gen-l10n` emits
/// a typed getter per *declared* key rather than a lookup-by-string map, so a key
/// that was never declared cannot be resolved at all. The localization layer is
/// out of scope for this task, as it was for Task 010.
///
/// In Task 010 this compromise sat on a placeholder page. It has now been
/// promoted into the permanent navigation bar, where an Arabic user sees seven
/// English labels at the bottom of every screen. That is a materially worse
/// defect than it was, and the fix — adding eight ARB keys and deleting this
/// function — is roughly fifteen minutes of work.
///
/// The title is derived rather than hardcoded so that the wrongness stays
/// *visible*. A literal `'Dashboard'` would look finished and quietly fail
/// translation review.
String temporaryRouteTitle(RouteName name) {
  final String identifier = name.name;
  return identifier[0].toUpperCase() + identifier.substring(1);
}
