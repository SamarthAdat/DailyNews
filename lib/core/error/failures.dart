import 'package:equatable/equatable.dart';

import 'package:daily_news/core/error/exceptions.dart';

sealed class Failure extends Equatable implements Exception {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

final class ServerFailure extends Failure {
  const ServerFailure([String? message])
      : super(message ?? 'The news service is not responding right now.');
}

final class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('No internet connection. Check your network and try again.');
}

final class CacheFailure extends Failure {
  const CacheFailure([String? message])
      : super(message ?? 'Could not access data stored on this device.');
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure() : super('Something went wrong. Please try again.');
}

Failure mapToFailure(Object error) => switch (error) {
      Failure() => error,
      NetworkException() => const NetworkFailure(),
      ServerException(:final message) => ServerFailure(message),
      CacheException(:final message) => CacheFailure(message),
      _ => const UnexpectedFailure(),
    };
