import 'package:flutter/material.dart';

/// Root application widget for Wealth OS.
///
/// Task 004 scope: foundation only. No routing, no theme customization,
/// no localization, no providers.
class WealthOsApp extends StatelessWidget {
  const WealthOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Wealth OS',
      home: AppPlaceholderScreen(),
    );
  }
}

/// Temporary home surface.
///
/// Exists only so [WealthOsApp] has a valid `home` before routing is
/// introduced. Replaced by the router shell in a later task.
class AppPlaceholderScreen extends StatelessWidget {
  const AppPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Wealth OS'),
      ),
    );
  }
}
