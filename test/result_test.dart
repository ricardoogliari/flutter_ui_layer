import 'package:flutter_test/flutter_test.dart';
import 'package:atitus_flutter_ui_layer/result.dart'; // Assuming Result.dart is in lib

void main() {
  group('Result', () {
    group('Result.ok()', () {
      test('should create an Ok instance', () {
        // Arrange
        const value = 42;
        // Act
        final result = Result.ok(value);
        // Assert
        expect(result, isA<Ok<int>>());
        expect(result.isOk, isTrue);
        expect(result.isError, isFalse);
      });

      test('Ok instance should hold the provided value', () {
        // Arrange
        const value = 'Test String';
        // Act
        final result = Result.ok(value);
        // Assert
        expect((result as Ok<String>).value, value);
      });

      test('Ok.toString() should return correct format', () {
        // Arrange
        const value = 123;
        final result = Result.ok(value);
        // Act
        final stringRepresentation = result.toString();
        // Assert
        expect(stringRepresentation, 'Result<int>.ok(123)');
      });

       test('Ok.toString() for a custom class should show class name', () {
        // Arrange
        final value = _TestClass("data");
        final result = Result.ok(value);
        // Act
        final stringRepresentation = result.toString();
        // Assert
        expect(stringRepresentation, 'Result<_TestClass>.ok(TestClass: data)');
      });
    });

    group('Result.error()', () {
      test('should create an Error instance', () {
        // Arrange
        final exception = Exception('Something went wrong');
        // Act
        final result = Result<int>.error(exception); // Specify type for Error if value type is known
        // Assert
        expect(result, isA<Error<int>>());
        expect(result.isOk, isFalse);
        expect(result.isError, isTrue);
      });

      test('Error instance should hold the provided exception', () {
        // Arrange
        final exception = Exception('Test Exception');
        // Act
        final result = Result<String>.error(exception);
        // Assert
        expect((result as Error<String>).errorValue, exception);
      });

      test('Error.toString() should return correct format', () {
        // Arrange
        final exception = Exception('Network Error');
        final result = Result<bool>.error(exception);
        // Act
        final stringRepresentation = result.toString();
        // Assert
        // The default Exception.toString() is "Exception: Network Error"
        expect(stringRepresentation, 'Result<bool>.error(Exception: Network Error)');
      });
    });

    group('Result type casting and helpers', () {
      test('okValue should return value for Ok and throw for Error', () {
        final okResult = Result.ok(100);
        final errorResult = Result<int>.error(Exception("fail"));

        expect(okResult.okValue, 100);
        expect(() => errorResult.okValue, throwsA(isA<TypeError>())); // Or specific exception if Result defines one
      });

      test('errorValue should return error for Error and throw for Ok', () {
        final okResult = Result.ok(100);
        final errorResult = Result<int>.error(Exception("fail"));

        expect(errorResult.errorValue, isA<Exception>());
        expect(() => okResult.errorValue, throwsA(isA<TypeError>())); // Or specific exception
      });
    });
  });
}

class _TestClass {
  final String data;
  _TestClass(this.data);

  @override
  String toString() => 'TestClass: $data';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TestClass && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}
