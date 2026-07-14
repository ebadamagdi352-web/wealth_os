import 'package:flutter/material.dart';
import 'package:wealth_os/src/core/constants/app_constants.dart';
import 'package:wealth_os/src/localization/app_locales.dart';
import 'package:wealth_os/src/localization/generated/app_localizations.dart';
import 'package:wealth_os/src/routing/router/app_router.dart';

/// Re-exports [AppPlaceholderScreen] so that it remains importable from this
/// library.
///
/// The screen itself now lives in `routing/router/router_configuration.dart`,
/// beside the router that decides when to show it. It could not stay here: this
/// file imports the router, so the router importing this file back would create
/// a circular dependency between the app layer and the routing layer.
///
/// An `export` gives the symbol two valid import paths without giving it two
/// definitions. Anything already importing `src/app/app.dart` — including
/// `test/widget_test.dart` — continues to resolve it, unchanged.
export 'package:wealth_os/src/routing/router/router_configuration.dart'
    show AppPlaceholderScreen;

/// Root application widget for Wealth OS.
///
/// `MaterialApp.router`, not `MaterialApp`. There is no `home:` argument, and
/// there cannot be one: what is displayed is now decided by the route table, not
/// hardcoded into the root of the application. `AppPlaceholderScreen` did not
/// disappear — it became the screen for the `/` route.
///
/// The localization delegates are wired here because [ComingSoonPage] reads its
/// text from the ARB files, and `AppLocalizations.of(context)` throws on first
/// frame if the delegate is not installed.
///
/// The theme is **not** wired. `AppTheme` from Task 005 exists and is unused;
/// connecting it is a separate task, and doing it here would be scope creep into
/// a task about routing.
class WealthOsApp extends StatelessWidget {
  const WealthOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.instance,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocales.supportedLocales,
      localeListResolutionCallback: AppLocales.resolveFromDevice,
    );
  }
}
