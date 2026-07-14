/// Constants for the localization layer.
///
/// Language codes are ISO 639-1. They are declared once, here, so that a code
/// string is never typed twice in the codebase — a typo in `'ar'` would fail
/// silently at runtime by falling back to English, which is exactly the kind
/// of bug that survives to production.
abstract final class LocaleConstants {
  /// ISO 639-1 code for English.
  static const String englishLanguageCode = 'en';

  /// ISO 639-1 code for Arabic.
  static const String arabicLanguageCode = 'ar';

  /// Storage key under which the user's explicit language choice is persisted.
  ///
  /// Consumed by the settings layer in a later task. Declared here because the
  /// key belongs to the localization domain, not to whichever storage backend
  /// eventually holds it.
  static const String preferredLanguageStorageKey =
      'settings.locale.language_code';

  /// Value written to storage when the user has chosen to follow the device
  /// locale rather than pinning a language.
  ///
  /// A sentinel is used rather than deleting the key, so that "never chose"
  /// and "explicitly chose to follow the system" remain distinguishable.
  static const String systemLanguageSentinel = 'system';
}
