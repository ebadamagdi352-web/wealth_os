import 'package:equatable/equatable.dart';
import 'package:wealth_os/src/core/error/failure.dart';

/// The outcome of an operation that can fail.
///
/// A function returning `Result<Account>` cannot throw its expected errors past
/// its own signature. The caller *must* deal with both cases, because a
/// `switch` over a `sealed` type is checked for exhaustiveness — forgetting the
/// failure branch is a compile error, not a runtime surprise at 2am in someone
/// else's timezone.
///
/// This is not a replacement for exceptions. Exceptions remain correct for
/// genuine bugs — a null dereference, a broken invariant, an index out of
/// range. `Result` is for *expected* failure: the network is down, the input is
/// invalid, the disk is full. Those are outcomes, not defects, and the type
/// system should say so.
///
/// ```dart
/// final Result<Account> result = await repository.load(id);
///
/// switch (result) {
///   case Success<Account>(:final Account value):
///     show(value);
///   case Failed<Account>(:final Failure failure):
///     handle(failure);
/// }
/// ```
///
/// ## On the name `Failed`
///
/// The obvious name for the error variant is `Failure` — but that name is
/// already taken by the error hierarchy in `failure.dart`, and the two would
/// collide irreconcilably: this very file imports that one. `Failed<T>` is the
/// result *state*; the `Failure` it carries is the error *value*. See
/// TASK_008_REPORT.md.
sealed class Result<T> extends Equatable {
  const Result();

  /// Whether this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Whether this is a [Failed].
  bool get isFailure => this is Failed<T>;

  /// The value, or `null` if this is a failure.
  ///
  /// A convenience for call sites that genuinely do not care why something
  /// failed. Prefer a `switch` anywhere the failure matters — this getter
  /// throws away information, quietly, which is exactly what `Result` exists to
  /// prevent, so reach for it knowingly.
  T? get valueOrNull => switch (this) {
        Success<T>(:final T value) => value,
        Failed<T>() => null,
      };

  /// The failure, or `null` if this is a success.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Failed<T>(:final Failure failure) => failure,
      };

  /// The value, or [fallback] if this is a failure.
  T getOrElse(T fallback) => switch (this) {
        Success<T>(:final T value) => value,
        Failed<T>() => fallback,
      };

  /// Collapses both branches into a single value.
  ///
  /// The workhorse for turning a `Result` into something a widget can render,
  /// without the call site needing a `switch` of its own.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success<T>(:final T value) => onSuccess(value),
        Failed<T>(:final Failure failure) => onFailure(failure),
      };

  /// Transforms the value, leaving a failure untouched.
  ///
  /// Lets a chain of operations be written without unwrapping at every step.
  /// The failure propagates unchanged — which is the whole point: an error
  /// raised in the data layer arrives at the UI still carrying its original
  /// type and cause, rather than having been re-wrapped four times.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Success<T>(:final T value) => Success<R>(transform(value)),
        Failed<T>(:final Failure failure) => Failed<R>(failure),
      };

  /// Transforms the failure, leaving a value untouched.
  ///
  /// Used at layer boundaries — a `StorageFailure` from the data layer may need
  /// to become something the domain understands.
  Result<T> mapFailure(Failure Function(Failure failure) transform) =>
      switch (this) {
        Success<T>(:final T value) => Success<T>(value),
        Failed<T>(:final Failure failure) => Failed<T>(transform(failure)),
      };

  /// Chains an operation that itself returns a [Result].
  ///
  /// Without this, chaining two fallible calls means nesting a switch inside a
  /// switch. With it, the first failure short-circuits and the rest is skipped.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
        Success<T>(:final T value) => transform(value),
        Failed<T>(:final Failure failure) => Failed<R>(failure),
      };
}

/// An operation that succeeded, carrying its value.
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  List<Object?> get props => <Object?>[value];

  @override
  bool get stringify => true;
}

/// An operation that failed, carrying the [Failure] that explains why.
final class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => <Object?>[failure];

  @override
  bool get stringify => true;
}
