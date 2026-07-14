import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth_os/src/localization/app_locales.dart';
import 'package:wealth_os/src/shared/providers/settings.dart';

/// Owns the application's settings.
///
/// The only thing in the codebase permitted to construct a new [Settings].
/// Every mutation is a named intent — `setThemeMode`, `useSystemLanguage` —
/// rather than a generic `state = newValue`. That keeps validation and
/// invariants in one place instead of at every call site.
///
/// State lives in memory only. Nothing here reads or writes storage; see
/// [hydrate] for how that changes without altering this class's shape.
class SettingsController extends Notifier<Settings> {
  @override
  Settings build() => const Settings();

  // ---------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------

  /// Sets light, dark, or follow-the-device.
  void setThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }

  // ---------------------------------------------------------------------
  // Language
  // ---------------------------------------------------------------------

  /// Pins the application to [language], overriding the device.
  void setLanguage(AppLocale language) {
    state = state.copyWith(language: language);
  }

  /// Clears the pinned language and returns to following the device.
  ///
  /// A separate method rather than `setLanguage(null)`, so that "follow the
  /// system" reads as the deliberate choice it is at every call site.
  void useSystemLanguage() {
    state = state.copyWith(language: null);
  }

  // ---------------------------------------------------------------------
  // Formatting
  // ---------------------------------------------------------------------

  /// Sets which digit set numerals render in.
  void setNumberFormat(NumberFormatStyle numberFormat) {
    state = state.copyWith(numberFormat: numberFormat);
  }

  /// Sets the display currency.
  ///
  /// [currencyCode] must be a three-letter ISO 4217 code. It is normalised to
  /// upper case, so `'egp'` and `'EGP'` cannot become two different settings
  /// that compare unequal.
  ///
  /// Throws [ArgumentError] if the code is not three letters. This is checked
  /// rather than trusted because the value will eventually arrive from storage,
  /// where a corrupted or hand-edited entry is entirely possible — and a bad
  /// currency code surfaces as garbled money rather than as an error.
  void setCurrencyCode(String currencyCode) {
    final String normalised = currencyCode.trim().toUpperCase();

    final bool isValid = normalised.length == 3 &&
        normalised.codeUnits.every(
          (int unit) => unit >= 0x41 && unit <= 0x5A,
        );

    if (!isValid) {
      throw ArgumentError.value(
        currencyCode,
        'currencyCode',
        'Must be a three-letter ISO 4217 code, e.g. USD, EGP, SAR.',
      );
    }

    state = state.copyWith(currencyCode: normalised);
  }

  // ---------------------------------------------------------------------
  // Calendar
  // ---------------------------------------------------------------------

  /// Sets the day the user's week begins on.
  void setFirstDayOfWeek(FirstDayOfWeek firstDayOfWeek) {
    state = state.copyWith(firstDayOfWeek: firstDayOfWeek);
  }

  // ---------------------------------------------------------------------
  // Whole-object operations
  // ---------------------------------------------------------------------

  /// Replaces every setting at once.
  ///
  /// This is the seam persistence will use. A future storage layer restores a
  /// saved [Settings] by calling this exactly once at startup — it does not
  /// call five setters in sequence, which would emit five state changes and
  /// five rebuilds for what is logically one event.
  void hydrate(Settings settings) {
    state = settings;
  }

  /// Restores every setting to its default.
  void reset() {
    state = const Settings();
  }
}
