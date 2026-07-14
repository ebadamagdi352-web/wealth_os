import 'package:equatable/equatable.dart';
import 'package:wealth_os/src/routing/route_names.dart';

/// A single route: what it is called, where it lives, and how it behaves.
///
/// Pure data. It knows nothing about widgets, `GoRouter`, or navigation — it
/// describes a destination without any opinion about how one gets there. That
/// separation is what lets the route table be unit-tested, reasoned about, and
/// rendered into a navigation bar without a `WidgetTester` in sight.
///
/// Immutable, with a `const` constructor, so the entire route table is built at
/// compile time and allocates nothing at runtime.
///
/// The constructor performs no validation, because a `const` constructor cannot:
/// an `assert` inside one must be a constant expression, and `path.startsWith('/')`
/// is a method call, which is not. Validation therefore lives in
/// `RouteRegistry.validate()`, which runs against the whole table at once — and
/// is a better place for it anyway, since the interesting invariants (no
/// duplicate names, no duplicate paths, every name covered) are properties of
/// the *table*, not of any single route.
class AppRoute extends Equatable {
  const AppRoute({
    required this.name,
    required this.path,
    required this.titleKey,
    required this.iconKey,
    this.requiresAuthentication = false,
    this.showInNavigation = false,
  });

  /// The typed identifier. Unique across the registry.
  final RouteName name;

  /// The URL path. Absolute, and unique across the registry.
  final String path;

  /// The ARB key of this route's display title.
  ///
  /// A **key**, not a title. Nothing in this file is ever shown to a user: the
  /// product ships in English and Arabic, so a literal `'Dashboard'` stored here
  /// would be untranslatable by construction. The presentation layer looks this
  /// key up against the active locale.
  final String titleKey;

  /// A stable identifier for this route's icon.
  ///
  /// A string, deliberately — Flutter's `IconData` lives behind a Flutter import,
  /// and this file has none. The presentation layer maps the key to a concrete
  /// icon. That indirection is also what allows the icon set to be swapped,
  /// themed, or replaced with custom assets without touching the route table.
  final String iconKey;

  /// Whether a signed-in user is required to reach this route.
  ///
  /// Every route is currently `false`, and that is an accurate statement rather
  /// than a default: **no authentication exists in this codebase yet.** A flag
  /// claiming a route is protected while nothing enforces it is worse than no
  /// flag at all — it invites the reader to believe a guarantee that is not
  /// there. These flip when a guard exists to honour them.
  final bool requiresAuthentication;

  /// Whether this route should appear in a navigation surface.
  ///
  /// Describes intent, not layout. It says "this is a destination a user should
  /// be able to reach directly", and leaves the question of a bottom bar versus
  /// a drawer versus an overflow menu entirely to the presentation layer.
  final bool showInNavigation;

  /// The route name as the string `GoRouter` expects for named routes.
  String get nameValue => name.name;

  @override
  List<Object?> get props => <Object?>[
        name,
        path,
        titleKey,
        iconKey,
        requiresAuthentication,
        showInNavigation,
      ];

  @override
  bool get stringify => true;
}
