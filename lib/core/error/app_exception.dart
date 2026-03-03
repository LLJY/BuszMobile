/// Typed exception hierarchy for the BuszMobile app.
///
/// Use [AppException.from] to classify raw exceptions into typed subtypes.
/// The sealed class enables exhaustive pattern matching in error handlers.
library;

import 'package:connectrpc/connect.dart';

// =============================================================================
// Exception Hierarchy
// =============================================================================

/// Base exception type for all app-level errors.
///
/// Provides both a [userMessage] for UI display and a [debugMessage] for logs.
sealed class AppException implements Exception {
  /// Private generative constructor for subclasses.
  AppException._();

  /// Human-readable message suitable for display in the UI.
  String get userMessage;

  /// Technical detail for logging and debugging.
  String get debugMessage;

  /// Classifies a raw exception into the appropriate [AppException] subtype.
  ///
  /// Classification rules:
  /// - Already an [AppException] → returned as-is (no double-wrapping)
  /// - [ConnectException] with [Code.unauthenticated] or
  ///   [Code.permissionDenied] → [AuthException]
  /// - [ConnectException] with [Code.deadlineExceeded] → [TimeoutException]
  /// - [ConnectException] with any other code → [ServerException]
  /// - All other exceptions → [NetworkException]
  factory AppException.from(Object error) {
    if (error is AppException) return error;

    if (error is ConnectException) {
      return switch (error.code) {
        Code.unauthenticated ||
        Code.permissionDenied => AuthException(debugMessage: error.toString()),
        Code.deadlineExceeded => TimeoutException(
          debugMessage: error.toString(),
        ),
        _ => ServerException(debugMessage: error.toString()),
      };
    }

    return NetworkException(debugMessage: error.toString());
  }
}

// =============================================================================
// Concrete Exception Types
// =============================================================================

/// Network connectivity error (e.g., no internet, DNS failure).
class NetworkException extends AppException {
  @override
  final String debugMessage;

  @override
  String get userMessage =>
      'Could not connect. Check your internet connection.';

  NetworkException({required this.debugMessage}) : super._();

  @override
  String toString() => 'NetworkException: $debugMessage';
}

/// Authentication or authorization error.
class AuthException extends AppException {
  @override
  final String debugMessage;

  @override
  String get userMessage => 'Session expired. Please restart the app.';

  AuthException({required this.debugMessage}) : super._();

  @override
  String toString() => 'AuthException: $debugMessage';
}

/// Server-side error (e.g., unavailable, internal error).
class ServerException extends AppException {
  @override
  final String debugMessage;

  @override
  String get userMessage => 'Server error. Please try again later.';

  ServerException({required this.debugMessage}) : super._();

  @override
  String toString() => 'ServerException: $debugMessage';
}

/// Request timed out.
class TimeoutException extends AppException {
  @override
  final String debugMessage;

  @override
  String get userMessage => 'Request timed out. Please try again.';

  TimeoutException({required this.debugMessage}) : super._();

  @override
  String toString() => 'TimeoutException: $debugMessage';
}
