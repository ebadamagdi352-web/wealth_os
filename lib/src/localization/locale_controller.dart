import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth_os/src/localization/app_locales.dart';

/// Holds the user's language choice.
///
/// State is `AppLocale?`, and the `null` case is load-bearing:
///
/// * `null` — no explicit choice. Follow whatever the device says, and keep
///   following it if the user changes their phone's language.
/// * non-null — the user pinned a language. Honour it regardless of the device.
///
/// Collapsing these two into a single non-null value would lose the
/// distinction, and the app would stop tracking the system locale the moment
/// it booted once.
class LocaleController extends Notifier<AppLocale?> {
  @override
  AppLocale? build() => null;

  /// Pins the application to [locale], overriding the device language.
  void setLocale(AppLocale locale) {
    state = locale;
  }

  /// Clears the explicit choice and returns to following the device language.
  void useSystemLocale() {
    state = null;
  }
}

/// The user's language choice. `null` means "follow the device".
final NotifierProvider<LocaleController, AppLocale?> localeControllerProvider =
    NotifierProvider<LocaleController, AppLocale?>(LocaleController.new);

/// The value handed to `MaterialApp.locale`.
///
/// `null` is deliberate and correct here: passing `null` tells `MaterialApp`
/// to run its own resolution against the device locales, which is exactly the
/// behaviour wanted when the user has not pinned a language.
final Provider<Locale?> appLocaleProvider = Provider<Locale?>((Ref ref) {
  return ref.watch(localeControllerProvider)?.locale;
});

/// The language actually in effect, with the device and fallback resolved.
///
/// Use this for anything that needs to *know* the language — reading
/// direction, number formatting, a settings screen showing the active choice.
/// Unlike [appLocaleProvider] it is never null, so callers never re-implement
/// the fallback rule.
final Provider<AppLocale> effectiveLocaleProvider = Provider<AppLocale>((
  Ref ref,
) {
  final AppLocale? chosen = ref.watch(localeControllerProvider);
  if (chosen != null) {
    return chosen;
  }
  final List<Locale> deviceLocales =
      WidgetsBinding.instance.platformDispatcher.locales;
  for (final Locale deviceLocale in deviceLocales) {
    final AppLocale? match = AppLocales.fromLanguageCode(
      deviceLocale.languageCode,
    );
    if (match != null) {
      return match;
    }
  }
  return AppLocales.fallback;
});
