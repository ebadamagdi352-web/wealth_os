import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth_os/src/app/app.dart';

/// Starts the Wealth OS application.
///
/// Wraps [WealthOsApp] in a [ProviderScope] — the container every Riverpod
/// provider is read from. It must sit at the very root, above the app, because a
/// `ref.watch` anywhere in the tree walks *up* to find it; without one, any
/// `ConsumerWidget` (the accounts screen, as of Task 020D) throws
/// "No ProviderScope found" on its first build.
///
/// This is the whole of the change. `ProviderScope` is a transparent wrapper — it
/// renders its child and nothing else — so routing, theme, localization, and every
/// on-screen behaviour are exactly as before. What changes is only that providers
/// are now reachable.
void bootstrap() {
  runApp(const ProviderScope(child: WealthOsApp()));
}
