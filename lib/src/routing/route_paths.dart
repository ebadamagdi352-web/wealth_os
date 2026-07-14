/// The URL path of every route.
///
/// Paths are declared here and pinned to a [RouteName] exactly once, in
/// `route_registry.dart`. Nothing else in the codebase should contain a path
/// literal — a screen that navigates by writing `'/accounts'` inline has
/// quietly created a second definition of that route, and the two will
/// eventually disagree.
///
/// ## These strings are a public contract
///
/// A path is not an internal identifier. It appears in deep links, in push
/// notification payloads, in emails, and in the browser address bar on web.
/// Once a link is in the wild, changing the path breaks it — permanently, for
/// people who are not in the room. Renaming a [RouteName] costs nothing;
/// renaming a path costs a redirect that must be maintained forever.
///
/// Choose them as though they are permanent, because they are.
abstract final class RoutePaths {
  /// The application root.
  static const String home = '/';

  static const String dashboard = '/dashboard';

  static const String accounts = '/accounts';

  static const String transactions = '/transactions';

  static const String assets = '/assets';

  static const String goals = '/goals';

  static const String reports = '/reports';

  static const String settings = '/settings';
}
