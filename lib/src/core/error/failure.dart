import 'package:equatable/equatable.dart';

/// The base type for everything that can go wrong.
///
/// `sealed`, so a `switch` over a [Failure] is checked for exhaustiveness by
/// the compiler. Add a fifth failure type and every `switch` that does not
/// handle it stops compiling — which is the entire reason to use a sealed
/// hierarchy rather than a plain base class. Silent fall-through to a default
/// branch is how error handling rots.
///
/// ## [message] is for developers, never for users
///
/// It is an English diagnostic string destined for logs and crash reports. It
/// must **never** be rendered in the UI. User-facing text is produced by
/// mapping the failure's *type* to a localized string, because a user reading
/// Arabic cannot be shown "Connection timed out", and a message baked in at the
/// point the error was raised cannot be translated after the fact.
///
/// The type is the contract. The message is a note to whoever is reading the
/// logs at 3am.
sealed class Failure extends Equatable {
  const Failure({
    required this.message,
    this.cause,
    this.stackTrace,
  });

  /// Developer-facing diagnostic. Not for display.
  final String message;

  /// The underlying error, if this failure wraps one.
  ///
  /// Kept so that the original exception is not thrown away at the boundary —
  /// a `StorageFailure` that discards the `SqliteException` beneath it is a
  /// failure report with the useful part removed.
  final Object? cause;

  /// Where the underlying error was thrown.
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => <Object?>[message, cause];

  @override
  bool get stringify => true;
}

/// Input did not satisfy a rule.
///
/// The user typed a negative amount, left a required field empty, chose a date
/// in the future. Expected, recoverable, and the user's next action is obvious.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldName,
    super.cause,
    super.stackTrace,
  });

  /// Which field failed, when the failure is attributable to one.
  ///
  /// Lets a form highlight the offending input rather than showing a banner and
  /// leaving the user to guess.
  final String? fieldName;

  @override
  List<Object?> get props => <Object?>[...super.props, fieldName];
}

/// A network operation failed.
///
/// The product is offline-first, so this is rarely fatal — but it is always
/// worth distinguishing, because the correct response is "retry later" rather
/// than "tell the user they did something wrong".
final class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    this.statusCode,
    super.cause,
    super.stackTrace,
  });

  /// HTTP status, when the failure came from a response rather than a timeout
  /// or a dead socket. Null means the request never got an answer at all —
  /// a meaningful distinction, and one that a bare `statusCode: 0` would hide.
  final int? statusCode;

  @override
  List<Object?> get props => <Object?>[...super.props, statusCode];
}

/// Reading or writing local data failed.
///
/// Disk full, database locked, corrupted row, migration failed. In an
/// offline-first product this is the serious one: the user's data is the
/// product, and a storage failure means the app has stopped being trustworthy.
final class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.cause,
    super.stackTrace,
  });
}

/// Something failed that no other case describes.
///
/// This exists so that a `catch` at a boundary always has somewhere to put an
/// unexpected exception, rather than being tempted to swallow it. It is not a
/// dumping ground: a recurring [UnknownFailure] in the logs is a signal that a
/// new typed failure needs to exist.
final class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.cause,
    super.stackTrace,
  });
}
