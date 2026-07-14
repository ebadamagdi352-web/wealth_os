import 'package:go_router/go_router.dart';
import 'package:wealth_os/src/routing/router/router_configuration.dart';

/// The application's router.
///
/// Exactly one [GoRouter] exists, for the life of the process.
///
/// This is not a stylistic preference. A `GoRouter` **owns the navigation
/// stack**. Build a second one and you have a second history: the user's back
/// button stops working, `canPop` lies, and a rebuild that happens to
/// re-instantiate the router silently throws the user back to the initial
/// location with no explanation. The most common way to cause this is to
/// construct `GoRouter` inside a widget's `build` method, where it is rebuilt
/// every frame.
///
/// [instance] is `static final`, so it is created lazily on first access and
/// then never again, regardless of how many times the widget tree rebuilds.
///
/// ## Why this is not a Riverpod provider
///
/// It should eventually be one — a router that must react to sign-in state or a
/// locale change needs to be scoped, and its guard will need to read providers.
/// But `bootstrap.dart` does not currently install a `ProviderScope`, and this
/// task does not permit modifying it. A provider with no scope to live in throws
/// at runtime the moment it is read.
///
/// So the router is a plain static for now. A real limitation with a scheduled
/// fix, not a design position — see TASK_010_REPORT.md.
abstract final class AppRouter {
  /// The one and only router. Fed to `MaterialApp.router`.
  static final GoRouter instance = RouterConfiguration.create();
}
