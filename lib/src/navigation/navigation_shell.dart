import 'package:flutter/material.dart';
import 'package:wealth_os/src/navigation/navigation_destination.dart';

/// The application shell: a body, with a Material 3 navigation bar beneath it.
///
/// Owns navigation **UI** and nothing else. It holds no state, reads no
/// provider, knows no business rule, and — deliberately — **has never heard of
/// GoRouter.**
///
/// That last point is the design decision in this file. The shell takes a
/// [child], a [currentIndex], and an [onDestinationSelected] callback. It does
/// not take a `StatefulNavigationShell`. The adapter in
/// `router_configuration.dart` unwraps GoRouter's type into those three plain
/// values before handing them over.
///
/// The cost is one adapting closure. The benefit is that the shell can be pumped
/// in a widget test with three literals and no router at all, and that replacing
/// GoRouter would not touch this file.
class NavigationShell extends StatelessWidget {
  const NavigationShell({
    required this.child,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  /// The active destination's screen.
  final Widget child;

  /// Index of the active destination, into [AppNavigationDestination.all].
  final int currentIndex;

  /// Called with the index of a tapped destination.
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final List<AppNavigationDestination> destinations =
        AppNavigationDestination.all;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        // Seven destinations do not fit a phone with their labels always
        // visible. Showing only the selected label is the honest mitigation
        // available without changing the route table — see TASK_011_REPORT.md,
        // which argues that the real fix is fewer destinations, not smaller text.
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: <Widget>[
          for (final AppNavigationDestination destination in destinations)
            NavigationDestination(
              icon: Icon(NavigationIcons.unselected(destination.iconKey)),
              selectedIcon: Icon(NavigationIcons.selected(destination.iconKey)),
              label: destination.temporaryLabel,
            ),
        ],
      ),
    );
  }
}

/// Resolves an [AppNavigationDestination.iconKey] to a Material icon.
///
/// The indirection exists so that `AppRoute` and `AppNavigationDestination` stay
/// pure Dart. `IconData` lives behind a Flutter import; a route table that
/// carried one could not be unit-tested without a widget binding.
///
/// Material 3 pairs an **outlined** icon for the unselected state with a
/// **filled** one for the selected state. That contrast is how the bar signals
/// the current destination without relying on colour alone — which matters for
/// the same reason gain and loss are not pure red and green in the design system.
abstract final class NavigationIcons {
  static const Map<String, IconData> _unselected = <String, IconData>{
    'home': Icons.home_outlined,
    'dashboard': Icons.dashboard_outlined,
    'account_balance': Icons.account_balance_outlined,
    'swap_horiz': Icons.swap_horiz_outlined,
    'diamond': Icons.diamond_outlined,
    'flag': Icons.flag_outlined,
    'bar_chart': Icons.bar_chart_outlined,
    'settings': Icons.settings_outlined,
  };

  static const Map<String, IconData> _selected = <String, IconData>{
    'home': Icons.home,
    'dashboard': Icons.dashboard,
    'account_balance': Icons.account_balance,
    'swap_horiz': Icons.swap_horiz,
    'diamond': Icons.diamond,
    'flag': Icons.flag,
    'bar_chart': Icons.bar_chart,
    'settings': Icons.settings,
  };

  /// Fallback for a key with no mapping.
  ///
  /// A missing icon must not crash the application — a navigation bar that
  /// throws is worse than one with a generic glyph in it. The fallback is
  /// visually obvious, so an unmapped key is noticed rather than silently
  /// tolerated.
  static const IconData fallback = Icons.circle_outlined;

  /// The unselected-state icon for [iconKey].
  static IconData unselected(String iconKey) =>
      _unselected[iconKey] ?? fallback;

  /// The selected-state icon for [iconKey].
  static IconData selected(String iconKey) =>
      _selected[iconKey] ?? _unselected[iconKey] ?? fallback;
}
