import 'package:flutter/material.dart' show ThemeMode;
import 'package:wealth_os/src/localization/app_locales.dart';

/// Application-wide constants.
///
/// The one place a default lives. Everything else in the codebase should point
/// here rather than restate a value — a default currency written down in two
/// files is a default currency that will eventually disagree with itself, and
/// the disagreement will surface as money displayed in the wrong denomination.
///
/// Two Flutter/localization imports are present and both are deliberate:
/// [defaultThemeMode] is a `ThemeMode` because `MaterialApp` consumes that type
/// directly, and [supportedLanguages] is derived from [AppLocale] rather than
/// re-listing the languages. See TASK_008_REPORT.md for why the second one is a
/// layering compromise with a scheduled fix.
abstract final class AppConstants {
  // ---------------------------------------------------------------------
  // Identity
  // ---------------------------------------------------------------------

  /// The product name. Not translated — brand names never are.
  static const String appName = 'Wealth OS';

  /// Semantic version, mirroring `pubspec.yaml`.
  ///
  /// Hand-maintained, and therefore capable of drifting from the real thing.
  /// The correct fix is to read the value from the platform at runtime rather
  /// than restate it here, which needs a package this task forbids. Recorded in
  /// TASK_008_REPORT.md so the duplication is a known, scheduled item rather
  /// than a lie waiting to be discovered in an about screen.
  static const String appVersion = '1.0.0';

  /// Build number, mirroring the `+N` suffix in `pubspec.yaml`.
  static const int appBuildNumber = 1;

  /// Version and build together, as displayed in diagnostics.
  static const String appVersionFull = '$appVersion+$appBuildNumber';

  // ---------------------------------------------------------------------
  // Languages
  // ---------------------------------------------------------------------

  /// Every language the product supports.
  ///
  /// Derived from [AppLocale], never re-listed. Adding a language means adding
  /// one enum value; this list follows automatically, and cannot fall out of
  /// step with the ARB files.
  static List<AppLocale> get supportedLanguages => AppLocale.values;

  /// The supported languages as ISO 639-1 codes.
  static List<String> get supportedLanguageCodes => AppLocale.values
      .map((AppLocale language) => language.languageCode)
      .toList(growable: false);

  /// The language used when the device's language is not supported.
  static const AppLocale fallbackLanguage = AppLocales.fallback;

  // ---------------------------------------------------------------------
  // Defaults
  // ---------------------------------------------------------------------

  /// ISO 4217 code used until the user chooses otherwise.
  ///
  /// A concrete value, not an absence. Every amount in the product must be
  /// denominated in *something* from the first frame, and a nullable default
  /// would push a null check into every formatting call site forever.
  static const String defaultCurrencyCode = 'USD';

  /// Theme used until the user chooses otherwise.
  ///
  /// Following the device is the right default: a user who has set their phone
  /// to dark mode has already told us what they want, and asking again is
  /// asking them to repeat themselves.
  static const ThemeMode defaultThemeMode = ThemeMode.system;

  // ---------------------------------------------------------------------
  // Money
  // ---------------------------------------------------------------------

  /// Decimal places used when rendering a currency amount.
  ///
  /// Two is correct for the great majority of currencies but **not all** — the
  /// Kuwaiti dinar uses three, the Japanese yen uses none. This constant is the
  /// default, not the law; a currency-aware formatter must override it, and one
  /// that does not will misprint every JOD and KWD amount in the product.
  static const int defaultFractionDigits = 2;
}
