/// The build this binary was produced for.
///
/// Selected at **compile time**, never at runtime. There is no `.env` file, no
/// config service, no remote flag. The environment is baked into the binary by
/// `--dart-define`, which means a production build physically cannot be talked
/// into behaving like a development build — there is no code path that reads a
/// value and switches. For a product that holds people's financial data, that
/// property is worth more than the convenience of runtime switching.
enum AppEnvironment {
  development(displayName: 'Development'),
  staging(displayName: 'Staging'),
  production(displayName: 'Production');

  const AppEnvironment({required this.displayName});

  /// Human-readable name, for logs and diagnostic screens.
  final String displayName;

  bool get isDevelopment => this == AppEnvironment.development;

  bool get isStaging => this == AppEnvironment.staging;

  bool get isProduction => this == AppEnvironment.production;

  /// True for any build that is not production.
  ///
  /// The useful question is almost always "is this production?" rather than
  /// "is this development?", because staging must behave like production in
  /// every respect that matters — that is the entire point of having it.
  bool get isPreProduction => this != AppEnvironment.production;
}

/// Resolves the active [AppEnvironment] from the compile-time environment.
///
/// Build commands:
///
/// ```
/// flutter build apk --dart-define=APP_ENV=development
/// flutter build apk --dart-define=APP_ENV=staging
/// flutter build apk --dart-define=APP_ENV=production
/// ```
///
/// Omitting the define yields [AppEnvironment.development]. That default is
/// deliberate and the safe way round: an unconfigured build behaves like the
/// *least* trusted environment, so forgetting the flag can never accidentally
/// produce something that thinks it is production.
abstract final class AppEnvironmentConfig {
  /// The dart-define key. Declared once so it cannot be misspelled twice.
  static const String defineKey = 'APP_ENV';

  static const String _developmentName = 'development';
  static const String _stagingName = 'staging';
  static const String _productionName = 'production';

  static const String _rawValue = String.fromEnvironment(
    defineKey,
    defaultValue: _developmentName,
  );

  /// The active environment.
  ///
  /// `const`, not `final`. This matters: because the value is known at compile
  /// time, `if (AppEnvironmentConfig.current.isProduction)` is resolved by the
  /// compiler, and the branch that is not taken is eliminated from the binary
  /// entirely. Debug-only code does not merely fail to run in production — it
  /// is not shipped.
  static const AppEnvironment current = _rawValue == _productionName
      ? AppEnvironment.production
      : _rawValue == _stagingName
          ? AppEnvironment.staging
          : AppEnvironment.development;

  /// Whether the supplied value was one this app recognises.
  ///
  /// A typo — `--dart-define=APP_ENV=prod` — silently falls through to
  /// development, because an unrecognised string cannot be distinguished from
  /// an absent one in a constant expression. That failure is quiet, which makes
  /// it dangerous, so it is surfaced here as a value that startup code can
  /// assert on rather than left to be noticed in the field.
  static const bool isRecognisedValue = _rawValue == _developmentName ||
      _rawValue == _stagingName ||
      _rawValue == _productionName;

  /// The raw string that was supplied, for diagnostics.
  static const String rawValue = _rawValue;
}
