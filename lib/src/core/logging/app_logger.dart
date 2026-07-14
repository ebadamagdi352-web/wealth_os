import 'dart:developer' as developer;

import 'package:wealth_os/src/core/environment/app_environment.dart';

/// Severity of a log record.
///
/// Ordered. [index] is compared directly, so a logger can be told "warning and
/// above" without a lookup table.
enum LogLevel {
  debug(label: 'DEBUG', developerLevel: 500),
  info(label: 'INFO', developerLevel: 800),
  warning(label: 'WARNING', developerLevel: 900),
  error(label: 'ERROR', developerLevel: 1000);

  const LogLevel({required this.label, required this.developerLevel});

  final String label;

  /// The `dart:developer` level, which follows the `package:logging` scale.
  final int developerLevel;

  /// Whether a record at this level should be emitted by a logger whose
  /// threshold is [minimum].
  bool meets(LogLevel minimum) => index >= minimum.index;
}

/// What the application logs through.
///
/// An interface, not a class, so the console implementation below can be
/// swapped for a crash reporter, a file sink, or a fan-out to several — without
/// a single call site changing. That is the entire reason this abstraction
/// exists ahead of any need for it: log calls end up scattered across hundreds
/// of files, and retrofitting an interface after the fact means touching all of
/// them.
abstract interface class AppLogger {
  /// Fine-grained detail. Stripped in production.
  void debug(String message);

  /// Something noteworthy happened, and it went as expected.
  void info(String message);

  /// Something is wrong but the operation continued.
  void warning(String message, {Object? cause, StackTrace? stackTrace});

  /// Something failed.
  void error(String message, {Object? cause, StackTrace? stackTrace});
}

/// Writes to the debug console via `dart:developer`.
///
/// ## Why `developer.log` and not `print`
///
/// Three reasons, in ascending order of importance:
///
/// 1. `print` is flagged by `avoid_print`, so it would fail `flutter analyze`.
/// 2. `developer.log` carries structured fields — level, name, error object,
///    stack trace — which DevTools renders as filterable, expandable records
///    rather than as a wall of undifferentiated text.
/// 3. `print` output is truncated by the Android log buffer on long messages.
///    A stack trace is a long message.
class ConsoleLogger implements AppLogger {
  /// Creates a console logger.
  ///
  /// [minimumLevel] defaults to [defaultLevelFor] the active environment:
  /// everything in development, warnings and errors in production. Debug logs
  /// in a shipped financial app are not merely noise — they are a slow leak of
  /// a user's account details into a log buffer that other software can read.
  ConsoleLogger({
    LogLevel? minimumLevel,
    String name = defaultName,
  })  : minimumLevel =
            minimumLevel ?? defaultLevelFor(AppEnvironmentConfig.current),
        _name = name;

  /// The channel name records are tagged with in DevTools.
  static const String defaultName = 'WealthOS';

  /// The threshold appropriate to [environment].
  static LogLevel defaultLevelFor(AppEnvironment environment) =>
      environment.isProduction ? LogLevel.warning : LogLevel.debug;

  /// Records below this level are discarded.
  final LogLevel minimumLevel;

  final String _name;

  @override
  void debug(String message) => _write(LogLevel.debug, message);

  @override
  void info(String message) => _write(LogLevel.info, message);

  @override
  void warning(String message, {Object? cause, StackTrace? stackTrace}) =>
      _write(LogLevel.warning, message, cause: cause, stackTrace: stackTrace);

  @override
  void error(String message, {Object? cause, StackTrace? stackTrace}) =>
      _write(LogLevel.error, message, cause: cause, stackTrace: stackTrace);

  void _write(
    LogLevel level,
    String message, {
    Object? cause,
    StackTrace? stackTrace,
  }) {
    if (!level.meets(minimumLevel)) {
      return;
    }

    developer.log(
      message,
      name: '$_name/${level.label}',
      level: level.developerLevel,
      error: cause,
      stackTrace: stackTrace,
    );
  }
}
