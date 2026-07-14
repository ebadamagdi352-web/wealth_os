import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth_os/src/localization/app_locales.dart';
import 'package:wealth_os/src/shared/providers/settings.dart';
import 'package:wealth_os/src/shared/providers/settings_controller.dart';

/// The single source of truth for application settings — **including language**.
///
/// `lib/src/localization/locale_controller.dart` is deleted. It held a second,
/// independently writable copy of the user's language, and two writable owners
/// of one value is not a style disagreement — it is a bug waiting for the first
/// screen that writes to one and reads from the other.
///
/// The localization layer is now stateless: `app_locales.dart` and
/// `locale_constants.dart` define *what the languages are* and how to resolve
/// one, but hold no state and own no provider. State lives here, because
/// language **is** a setting.
///
/// Dependencies point one way and only one way:
///
/// ```
/// shared/providers  ──▶  localization
/// ```
///
/// Watch this provider only if you need the whole object — a settings screen,
/// or a persistence listener. Everything else watches one of the derived
/// providers below.
final NotifierProvider<SettingsController, Settings> settingsProvider =
    NotifierProvider<SettingsController, Settings>(SettingsController.new);

// -------------------------------------------------------------------------
// Derived providers.
//
// Each uses `.select`, so it emits a change only when *its* field changes.
// Without them, `MaterialApp` would watch the entire Settings object and
// rebuild the whole application tree because the user picked a different
// currency. With them, changing the currency notifies exactly the widgets that
// display money.
//
// Three lines per field, and it is the difference between a settings screen
// that feels instant and one that stutters.
// -------------------------------------------------------------------------

/// Fed to `MaterialApp.themeMode`.
final Provider<ThemeMode> themeModeProvider = Provider<ThemeMode>((Ref ref) {
  return ref.watch(
    settingsProvider.select((Settings s) => s.themeMode),
  );
});

/// The user's pinned language, or `null` if following the device.
///
/// This is the *choice*, not the *result*. For the language actually in force,
/// use [effectiveLanguageProvider].
final Provider<AppLocale?> languageProvider = Provider<AppLocale?>((Ref ref) {
  return ref.watch(
    settingsProvider.select((Settings s) => s.language),
  );
});

/// Fed to `MaterialApp.locale`.
///
/// `null` is deliberate and correct: it tells `MaterialApp` to run its own
/// resolution against the device's locale list, which is exactly the behaviour
/// wanted when the user has not pinned a language. Substituting a concrete
/// fallback here would permanently sever the app from the system locale.
final Provider<Locale?> appLocaleProvider = Provider<Locale?>((Ref ref) {
  return ref.watch(languageProvider)?.locale;
});

/// The language actually in effect, with device and fallback already resolved.
///
/// Never null. Use this for anything that needs to *know* the language rather
/// than hand it to `MaterialApp` — digit selection, a settings row showing the
/// current choice, previewing direction. Callers never re-implement the
/// fallback rule, so it cannot drift between screens.
///
/// Known limitation: the device locale is read once, when this provider is
/// first built. If the user changes their phone's language while the app is
/// running, this will not re-resolve on its own. Closing that gap requires a
/// `WidgetsBindingObserver` calling `ref.invalidate` from `didChangeLocales`,
/// which means touching `bootstrap.dart` — out of scope for this task.
final Provider<AppLocale> effectiveLanguageProvider = Provider<AppLocale>((
  Ref ref,
) {
  final AppLocale? pinned = ref.watch(languageProvider);
  if (pinned != null) {
    return pinned;
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

/// Which digit set numerals render in.
final Provider<NumberFormatStyle> numberFormatProvider =
    Provider<NumberFormatStyle>((Ref ref) {
  return ref.watch(
    settingsProvider.select((Settings s) => s.numberFormat),
  );
});

/// ISO 4217 code of the display currency.
final Provider<String> currencyCodeProvider = Provider<String>((Ref ref) {
  return ref.watch(
    settingsProvider.select((Settings s) => s.currencyCode),
  );
});

/// The day the user's week begins on.
final Provider<FirstDayOfWeek> firstDayOfWeekProvider =
    Provider<FirstDayOfWeek>((Ref ref) {
  return ref.watch(
    settingsProvider.select((Settings s) => s.firstDayOfWeek),
  );
});
