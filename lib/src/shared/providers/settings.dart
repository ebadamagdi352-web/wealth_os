import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wealth_os/src/localization/app_locales.dart';

/// How numerals are rendered.
///
/// This is not a cosmetic preference. Arabic is written with two different
/// digit sets: Western Arabic (`1234`) and Eastern Arabic-Indic (`١٢٣٤`). Both
/// are correct Arabic. Which one a reader expects varies by country and by
/// generation — Egypt and the Gulf lean Eastern, the Maghreb uses Western
/// almost exclusively — and no locale code can tell you which one *this* user
/// wants. It has to be a setting.
///
/// Separators travel with the digits: Eastern Arabic-Indic uses U+066C as the
/// thousands mark and U+066B as the decimal mark, not `,` and `.`.
enum NumberFormatStyle {
  /// Take the digit set implied by the active language.
  followLanguage,

  /// Always Western Arabic digits: `1,234.56`.
  western,

  /// Always Eastern Arabic-Indic digits: `١٬٢٣٤٫٥٦`.
  easternArabic,
}

/// The day a week starts on.
///
/// Only three values occur in practice, and the product's reporting periods
/// depend on getting this right: a "this week" spending total that starts on
/// the wrong day is silently wrong, not visibly broken.
///
/// * Saturday — Egypt and much of the Arab world.
/// * Sunday — United States, Canada, Japan.
/// * Monday — ISO 8601, most of Europe.
///
/// Adding a fourth is a one-line change: add the value, give it an
/// [isoWeekday]. Nothing else in the codebase needs to know.
enum FirstDayOfWeek {
  /// Defer to the platform's regional setting.
  system(isoWeekday: null),

  saturday(isoWeekday: DateTime.saturday),

  sunday(isoWeekday: DateTime.sunday),

  monday(isoWeekday: DateTime.monday);

  const FirstDayOfWeek({required this.isoWeekday});

  /// The `DateTime` weekday constant, or `null` for [system].
  ///
  /// `null` is not an oversight — [system] has no fixed answer until the
  /// platform is asked, and encoding a guess here would make the guess
  /// invisible.
  final int? isoWeekday;
}

/// Application settings. Immutable.
///
/// One object holds every user preference — including language, which lives
/// here and nowhere else. Not five providers holding one field each, because
/// settings are saved, restored, exported and reset as a *unit*, and a design
/// that scatters them makes each of those a five-way coordination problem.
@immutable
class Settings extends Equatable {
  const Settings({
    this.themeMode = ThemeMode.system,
    this.language,
    this.numberFormat = NumberFormatStyle.followLanguage,
    this.currencyCode = defaultCurrencyCode,
    this.firstDayOfWeek = FirstDayOfWeek.system,
  });

  /// ISO 4217 code used until the user chooses otherwise.
  ///
  /// A concrete default, not an absence. Every amount in the product must be
  /// denominated in *something* from the first frame, and a nullable currency
  /// would push a null check into every formatting call site forever.
  static const String defaultCurrencyCode = 'USD';

  /// Light, dark, or follow the device.
  ///
  /// Flutter's own [ThemeMode] is reused rather than redeclared. It already
  /// models exactly the three required cases, and `MaterialApp.themeMode`
  /// consumes it directly — an in-house copy would exist only to be converted
  /// back at the boundary.
  final ThemeMode themeMode;

  /// The user's pinned language, or `null` to follow the device.
  ///
  /// `null` carries meaning. It is not "unset" — it is the explicit state
  /// "track whatever the phone says, including if it changes later".
  final AppLocale? language;

  /// Which digit set numerals render in.
  final NumberFormatStyle numberFormat;

  /// ISO 4217 currency code, e.g. `USD`, `EGP`, `SAR`.
  ///
  /// A `String`, not an enum. There are ~180 active currency codes and the list
  /// changes; an enum would have to be edited every time a user wants a
  /// currency nobody anticipated. Validation lives in the controller, which is
  /// the only thing permitted to construct a new value.
  final String currencyCode;

  /// The day the user's week begins.
  final FirstDayOfWeek firstDayOfWeek;

  /// Whether the user has pinned a language rather than following the device.
  bool get hasExplicitLanguage => language != null;

  /// Sentinel distinguishing "argument omitted" from "argument was null".
  ///
  /// Without this, [copyWith] cannot express *set the language back to
  /// system*, because `copyWith(language: null)` is indistinguishable from
  /// `copyWith()` under the usual `??` implementation. The field would silently
  /// refuse to be cleared: once a user pinned Arabic they could never return to
  /// following the device.
  static const Object _unset = Object();

  Settings copyWith({
    ThemeMode? themeMode,
    Object? language = _unset,
    NumberFormatStyle? numberFormat,
    String? currencyCode,
    FirstDayOfWeek? firstDayOfWeek,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      language: identical(language, _unset)
          ? this.language
          : language as AppLocale?,
      numberFormat: numberFormat ?? this.numberFormat,
      currencyCode: currencyCode ?? this.currencyCode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        themeMode,
        language,
        numberFormat,
        currencyCode,
        firstDayOfWeek,
      ];

  @override
  bool get stringify => true;
}
