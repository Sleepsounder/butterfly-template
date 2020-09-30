import 'package:meta/meta.dart';

/// Represents the result of a potentially failed operation.
/// 
/// Conceptually, this object represents either the successful outcome `T`,
/// or an error `E`.
class Result<T, E> {
  /// `true` if this result is a success, `false` otherwise.
  final bool isSuccess;

  /// Returns `true` if this result is a failure, `false` otherwise.
  final bool isFailure;

  /// The success value, or `null` if this result is a failure.
  final T value;

  /// The failure value, or `null` if this result is a success.
  final E error;

  Result._({this.value, this.error, this.isSuccess, this.isFailure});

  /// Creates a success result with the provided `value`.
  factory Result.success(T value) {
    return Result._(value: value, isSuccess: true, isFailure: false);
  }

  /// Creates a failure result with the provided `error`.
  factory Result.failure(E error) {
    return Result._(error: error, isSuccess: false, isFailure: true);
  }

  /// Calls `onSuccess` if this result is a success or `onFailure` if this result
  /// is a failure.
  void fold({
    @required void Function(T) onSuccess, 
    @required void Function(E) onFailure
  }) {
    if (this.isSuccess) {
      onSuccess(this.value);
    } else {
      onFailure(this.error);
    }
  }

  /// Maps the success and error values of this result.
  Result<T2, E2> map<T2, E2>({
    @required T2 Function(T) success,
    @required E2 Function(E) failure
  }) {
    if (this.isSuccess) {
      return Result.success(success(this.value));
    } else {
      return Result.failure(failure(this.error));
    }
  }

  /// Maps the success value of this result.
  Result<T2, E> mapSuccess<T2>(T2 Function(T) transform) {
    return this.map(
      success: transform,
      failure: (error) => error
    );
  }

  /// Maps the error value of this result.
  Result<T, E2> mapError<E2>(E2 Function(E) transform) {
    return this.map(
      success: (value) => value,
      failure: transform
    );
  }
}