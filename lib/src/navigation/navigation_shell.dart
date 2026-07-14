import 'package:flutter/material.dart';
import 'package:wealth_os/src/navigation/navigation_destination.dart';

/// The application shell: a body, with a Material 3 navigation bar beneath it.
///
/// Owns navigation **UI** and nothing else. No state, no provider, no business
/// rule — and, deliberately, no knowledge of GoRouter. It takes a [child], a
/// [currentIndex], and a callback. The adapter in `router_configuration.dart`
/// unwraps GoRouter's type before handing them over, so this widget can be
/// pumped in a test with three literals and no router at all.
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

  /// Width one destination needs before its label can be shown.
  ///
  /// The longest label in the product is "Transactions" — twelve characters,
  /// which at 11sp occupies roughly 66 logical pixels, plus horizontal padding.
  /// Below [_labelMinWidth] the label has nowhere to go, and Material's
  /// `NavigationDestination` will wrap it onto a second line rather than clip it.
  ///
  /// This constant is what makes "labels must not wrap" a *guarantee* rather than
  /// a hope. It is measured against the real longest string, not guessed.
  static const double _labelMinWidth = 76;

  @override
  Widget build(BuildContext context) {
    final List<AppNavigationDestination> destinations =
        AppNavigationDestination.all;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Seven destinations on a 360dp phone leaves 51dp each. There is no
        // font size at which "Transactions" fits in 51dp — so rather than let it
        // wrap, the labels are dropped entirely and the bar becomes icon-only.
        //
        // Selection is still unmistakable: the pill indicator and the filled
        // icon both remain. Material 3 explicitly supports `alwaysHide` for
        // exactly this case.
        //
        // This is a mitigation, not a fix. The real fix is fewer destinations —
        // Material 3 specifies three to five, and this bar carries seven. That
        // requires `showInNavigation` to become a three-way placement so the
        // overflow can go behind a "More" destination, which lives in the route
        // registry and is outside this task's allowed files. See
        // TASK_013_REPORT.md.
        final double widthPerDestination =
            constraints.maxWidth / destinations.length;
        final bool labelsFit = widthPerDestination >= _labelMinWidth;

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelBehavior: labelsFit
                ? NavigationDestinationLabelBehavior.onlyShowSelected
                : NavigationDestinationLabelBehavior.alwaysHide,
            destinations: <Widget>[
              for (final AppNavigationDestination destination in destinations)
                NavigationDestination(
                  icon: Icon(NavigationIcons.unselected(destination.iconKey)),
                  selectedIcon:
                      Icon(NavigationIcons.selected(destination.iconKey)),
                  label: destination.temporaryLabel,
                  tooltip: destination.temporaryLabel,
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Resolves an [AppNavigationDestination.iconKey] to a Material icon.
///
/// The indirection exists so that `AppRoute` and `AppNavigationDestination` stay
/// pure Dart. `IconData` lives behind a Flutter import, and a route table
/// carrying one could not be unit-tested without a widget binding.
///
/// Material 3 pairs an **outlined** icon for the unselected state with a
/// **filled** one for selected. That contrast is how the bar signals the current
/// destination without relying on colour alone — and when labels are hidden on a
/// narrow phone, it is doing most of the work.
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
  /// A missing icon must not crash the application — a navigation bar that throws
  /// is worse than one with a generic glyph in it. The fallback is visually
  /// obvious, so an unmapped key gets noticed rather than silently tolerated.
  static const IconData fallback = Icons.circle_outlined;

  /// The unselected-state icon for [iconKey].
  static IconData unselected(String iconKey) => _unselected[iconKey] ?? fallback;

  /// The selected-state icon for [iconKey].
  static IconData selected(String iconKey) =>
      _selected[iconKey] ?? _unselected[iconKey] ?? fallback;
}
