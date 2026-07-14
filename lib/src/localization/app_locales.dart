import 'package:flutter/widgets.dart';
import 'package:wealth_os/src/localization/locale_constants.dart';

/// Every language Wealth OS supports.
///
/// Adding a language is a three-step change with no other edits anywhere:
///
/// 1. Add a value to this enum.
/// 2. Add `lib/l10n/app_<code>.arb`.
/// 3. Run `flutter gen-l10n`.
///
/// [AppLocales.supportedLocales] and every language picker built later derive
/// from [values], so nothing else needs to know the list grew. That is what
/// "supports unlimited translations" means in practice — the cost of the
/// eleventh language is identical to the cost of the third.
enum AppLocale {
  english(
    languageCode: LocaleConstants.englishLanguageCode,
    nativeName: 'English',
    englishName: 'English',
    textDirection: TextDirection.ltr,
  ),

  arabic(
    languageCode: LocaleConstants.arabicLanguageCode,
    nativeName: 'العربية',
    englishName: 'Arabic',
    textDirection: TextDirection.rtl,
  );

  const AppLocale({
    required this.languageCode,
    required this.nativeName,
    required this.englishName,
    required this.textDirection,
  });

  /// ISO 639-1 code, e.g. `en`.
  final String languageCode;

  /// The language's name written in that language — 'العربية', not 'Arabic'.
  ///
  /// A language picker must always list languages endonymically. A user who
  /// only reads Arabic cannot find "Arabic" in a list.
  final String nativeName;

  /// The language's name in English, for logs, diagnostics and admin tooling.
  final String englishName;

  /// Reading direction for this language.
  ///
  /// Note that Flutter resolves direction automatically once the localization
  /// delegates are registered — widgets do not need to consult this. It is
  /// exposed for the cases Flutter cannot infer: previewing a language the
  /// user is not currently in, and formatting decisions in code rather than
  /// layout.
  final TextDirection textDirection;

  /// The Flutter [Locale] this language maps to.
  Locale get locale => Locale(languageCode);

  /// Whether this language reads right-to-left.
  bool get isRtl => textDirection == TextDirection.rtl;
}

/// The surface that `MaterialApp` and the locale controller consume.
abstract final class AppLocales {
  /// The language used when no supported language matches the device.
  static const AppLocale fallback = AppLocale.english;

  /// Every supported language, in display order.
  static const List<AppLocale> all = AppLocale.values;

  /// Passed to `MaterialApp.supportedLocales`.
  static List<Locale> get supportedLocales =>
      AppLocale.values.map((AppLocale l) => l.locale).toList(growable: false);

  /// Finds a supported language by ISO 639-1 code, or `null` if unsupported.
  static AppLocale? fromLanguageCode(String? languageCode) {
    if (languageCode == null) {
      return null;
    }
    for (final AppLocale candidate in AppLocale.values) {
      if (candidate.languageCode == languageCode) {
        return candidate;
      }
    }
    return null;
  }

  /// Maps a Flutter [Locale] onto a supported language, falling back to
  /// [fallback] when the locale is unsupported.
  ///
  /// Only the language subtag is compared. A device reporting `ar-EG`,
  /// `ar-SA` or plain `ar` all resolve to [AppLocale.arabic] — the product
  /// does not maintain per-region variants, and pretending otherwise would
  /// mean a Saudi user silently getting English.
  static AppLocale resolve(Locale? locale) {
    if (locale == null) {
      return fallback;
    }
    return fromLanguageCode(locale.languageCode) ?? fallback;
  }

  /// Passed to `MaterialApp.localeListResolutionCallback`.
  ///
  /// The device supplies its language preferences in priority order. The first
  /// one this product supports wins; if none do, [fallback] is used.
  static Locale resolveFromDevice(
    List<Locale>? deviceLocales,
    Iterable<Locale> supported,
  ) {
    if (deviceLocales != null) {
      for (final Locale deviceLocale in deviceLocales) {
        final AppLocale? match = fromLanguageCode(deviceLocale.languageCode);
        if (match != null) {
          return match.locale;
        }
      }
    }
    return fallback.locale;
  }
}
