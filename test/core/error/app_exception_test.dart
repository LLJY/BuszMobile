/// Tests for [AppException] hierarchy and classification.
///
/// Verifies:
/// - Each subtype provides the correct [userMessage]
/// - [AppException.from] classifies [ConnectException] codes correctly
/// - [AppException.from] classifies generic exceptions as [NetworkException]
/// - [AppException.from] does not double-wrap existing [AppException]s
library;

import 'package:connectrpc/connect.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busz_mobile/core/error/app_exception.dart';

void main() {
  // ===========================================================================
  // User message tests
  // ===========================================================================

  group('userMessage', () {
    test('NetworkException has correct userMessage', () {
      final exception = NetworkException(debugMessage: 'socket closed');
      expect(
        exception.userMessage,
        'Could not connect. Check your internet connection.',
      );
    });

    test('AuthException has correct userMessage', () {
      final exception = AuthException(debugMessage: 'token expired');
      expect(exception.userMessage, 'Session expired. Please restart the app.');
    });

    test('ServerException has correct userMessage', () {
      final exception = ServerException(debugMessage: 'internal error');
      expect(exception.userMessage, 'Server error. Please try again later.');
    });

    test('TimeoutException has correct userMessage', () {
      final exception = TimeoutException(debugMessage: 'deadline exceeded');
      expect(exception.userMessage, 'Request timed out. Please try again.');
    });
  });

  // ===========================================================================
  // Classification tests (AppException.from)
  // ===========================================================================

  group('AppException.from', () {
    test('ConnectException with code unauthenticated → AuthException', () {
      final error = ConnectException(Code.unauthenticated, 'not logged in');
      final result = AppException.from(error);

      expect(result, isA<AuthException>());
      expect(result.debugMessage, contains('unauthenticated'));
    });

    test('ConnectException with code permissionDenied → AuthException', () {
      final error = ConnectException(Code.permissionDenied, 'forbidden');
      final result = AppException.from(error);

      expect(result, isA<AuthException>());
    });

    test('ConnectException with code unavailable → ServerException', () {
      final error = ConnectException(Code.unavailable, 'service down');
      final result = AppException.from(error);

      expect(result, isA<ServerException>());
      expect(result.debugMessage, contains('unavailable'));
    });

    test('ConnectException with code internal → ServerException', () {
      final error = ConnectException(Code.internal, 'null pointer');
      final result = AppException.from(error);

      expect(result, isA<ServerException>());
    });

    test('ConnectException with code deadlineExceeded → TimeoutException', () {
      final error = ConnectException(Code.deadlineExceeded, 'timed out');
      final result = AppException.from(error);

      expect(result, isA<TimeoutException>());
      expect(result.debugMessage, contains('deadline_exceeded'));
    });

    test('generic Exception → NetworkException', () {
      final error = Exception('something went wrong');
      final result = AppException.from(error);

      expect(result, isA<NetworkException>());
      expect(result.debugMessage, contains('something went wrong'));
    });

    test('generic non-Exception error → NetworkException', () {
      const error = 'raw string error';
      final result = AppException.from(error);

      expect(result, isA<NetworkException>());
      expect(result.debugMessage, 'raw string error');
    });

    test('existing AppException is returned as-is (no double-wrapping)', () {
      final original = ServerException(debugMessage: 'already typed');
      final result = AppException.from(original);

      expect(identical(result, original), isTrue);
    });
  });

  // ===========================================================================
  // Implements Exception
  // ===========================================================================

  group('type hierarchy', () {
    test('all subtypes implement Exception', () {
      expect(NetworkException(debugMessage: 'test'), isA<Exception>());
      expect(AuthException(debugMessage: 'test'), isA<Exception>());
      expect(ServerException(debugMessage: 'test'), isA<Exception>());
      expect(TimeoutException(debugMessage: 'test'), isA<Exception>());
    });

    test('all subtypes are AppException', () {
      expect(NetworkException(debugMessage: 'test'), isA<AppException>());
      expect(AuthException(debugMessage: 'test'), isA<AppException>());
      expect(ServerException(debugMessage: 'test'), isA<AppException>());
      expect(TimeoutException(debugMessage: 'test'), isA<AppException>());
    });
  });
}
