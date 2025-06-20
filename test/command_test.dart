import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:atitus_flutter_ui_layer/command.dart';
import 'package:atitus_flutter_ui_layer/result.dart';

// A simple listener counter to help verify notifyListeners calls indirectly
class ListenerCounter {
  int count = 0;
  void increment() {
    count++;
  }
}

void main() {
  /*
  group('Command0<T>', () {
    late Command0<String> command;
    late ListenerCounter listenerCounter;

    setUp(() {
      listenerCounter = ListenerCounter();
    });

    test('successful execution', () async {
      // Arrange
      const successData = 'Success Data';
      action() async => Result.ok(successData);
      command = Command0<String>(action);
      command.addListener(listenerCounter.increment);

      // Initial state
      expect(command.completed, isFalse);
      expect(command.error, isFalse);

      // Act
      final executionResult = await command.execute();

      // Assert
      expect(command.completed, isTrue);
      expect(command.error, isFalse);
      expect(executionResult is Ok, isTrue);
      expect(executionResult.okValue, successData);
      expect(command.result, isNotNull);
      expect(command.result!.isOk, isTrue);
      expect(command.result!.okValue, successData);
      // notifyListeners is called: 1. running=true, 2. running=false, completed=true/error=false, result=value
      expect(listenerCounter.count, 2, reason: "NotifyListeners should be called for start and end of execution.");
    });

    test('failed execution (action returns Result.error)', () async {
      // Arrange
      final failureException = Exception('Action Failed');
      CommandAction0<String> action = () async => Result.error(failureException);
      command = Command0<String>(action);
      command.addListener(listenerCounter.increment);

      // Act
      final executionResult = await command.execute();

      // Assert
      expect(command.running, isFalse);
      expect(command.completed, isFalse, reason: "Completed should be false on error");
      expect(command.error, isTrue);
      expect(executionResult.isError, isTrue);
      expect(executionResult.errorValue, failureException);
      expect(command.result, isNotNull);
      expect(command.result!.isError, isTrue);
      expect(command.result!.errorValue, failureException);
      expect(listenerCounter.count, 2);
    });

    test('action throws an exception', () async {
      // Arrange
      final thrownException = Exception('Action Threw');
      CommandAction0<String> action = () async {
        throw thrownException;
      };
      command = Command0<String>(action);
      command.addListener(listenerCounter.increment);

      // Act
      final executionResult = await command.execute();

      // Assert
      expect(command.running, isFalse);
      expect(command.completed, isFalse);
      expect(command.error, isTrue); // Error flag should be true
      expect(executionResult.isError, isTrue);
      expect(executionResult.errorValue, isA<Exception>()); // Error should be the thrown one
      expect(executionResult.errorValue, equals(thrownException));
      expect(command.result, isNotNull);
      expect(command.result!.isError, isTrue);
      expect(command.result!.errorValue, thrownException);
      expect(listenerCounter.count, 2);
    });

    test('no concurrent execution', () async {
      // Arrange
      int actionExecutionCount = 0;
      Completer<void> actionCompleter = Completer();
      CommandAction0<String> action = () async {
        actionExecutionCount++;
        await actionCompleter.future; // Simulate delay
        return Result.ok('Delayed Data');
      };
      command = Command0<String>(action);
      command.addListener(listenerCounter.increment);

      // Act
      final future1 = command.execute(); // First call
      expect(command.running, isTrue);

      final future2 = command.execute(); // Second call, should be ignored

      // Assert
      expect(command.running, isTrue); // Still running from first call

      actionCompleter.complete(); // Allow action to complete
      await future1;
      await future2; // This should return the result of the first execution or an error if designed that way

      expect(actionExecutionCount, 1, reason: "Action should only be executed once.");
      expect(command.running, isFalse);
      expect(command.completed, isTrue);
      // Listener count: 1. first execute start, 2. first execute end. Second execute does nothing.
      expect(listenerCounter.count, 2);
    });
  });

  group('Command1<T, A>', () {
    late Command1<String, int> command; // Returns String, takes int argument
    late ListenerCounter listenerCounter;

    setUp(() {
      listenerCounter = ListenerCounter();
    });

    test('successful execution with argument', () async {
      // Arrange
      const testArgument = 42;
      CommandAction1<String, int> action = (int arg) async {
        return Result.ok('Received: $arg');
      };
      command = Command1<String, int>(action);
      command.addListener(listenerCounter.increment);

      // Act
      final executionResult = await command.execute(testArgument);

      // Assert
      expect(command.running, isFalse);
      expect(command.completed, isTrue);
      expect(command.error, isFalse);
      expect(executionResult.isOk, isTrue);
      expect(executionResult.okValue, 'Received: $testArgument');
      expect(command.result!.okValue, 'Received: $testArgument');
      expect(listenerCounter.count, 2);
    });

    test('failed execution with argument (action returns Result.error)', () async {
      // Arrange
      const testArgument = 100;
      final failureException = Exception('Action Failed with Arg');
      CommandAction1<String, int> action = (int arg) async {
        return Result.error(failureException);
      };
      command = Command1<String, int>(action);
      command.addListener(listenerCounter.increment);

      // Act
      final executionResult = await command.execute(testArgument);

      // Assert
      expect(command.running, isFalse);
      expect(command.completed, isFalse);
      expect(command.error, isTrue);
      expect(executionResult.isError, isTrue);
      expect(executionResult.errorValue, failureException);
      expect(command.result!.errorValue, failureException);
      expect(listenerCounter.count, 2);
    });

    test('action throws an exception with argument', () async {
      // Arrange
      const testArgument = -1;
      final thrownException = Exception('Action Threw with Arg');
      CommandAction1<String, int> action = (int arg) async {
        throw thrownException;
      };
      command = Command1<String, int>(action);
      command.addListener(listenerCounter.increment);

      // Act
      final executionResult = await command.execute(testArgument);

      // Assert
      expect(command.running, isFalse);
      expect(command.completed, isFalse);
      expect(command.error, isTrue);
      expect(executionResult.isError, isTrue);
      expect(executionResult.errorValue, thrownException);
      expect(command.result!.errorValue, thrownException);
      expect(listenerCounter.count, 2);
    });

    test('no concurrent execution with argument', () async {
      // Arrange
      int actionExecutionCount = 0;
      String? receivedArg;
      Completer<void> actionCompleter = Completer();
      CommandAction1<String, String> action = (String arg) async {
        actionExecutionCount++;
        receivedArg = arg;
        await actionCompleter.future;
        return Result.ok('Delayed: $arg');
      };
      Command1<String, String> commandWithArg = Command1<String, String>(action);
      commandWithArg.addListener(listenerCounter.increment);

      // Act
      final future1 = commandWithArg.execute("arg1");
      expect(commandWithArg.running, isTrue);

      final future2 = commandWithArg.execute("arg2"); // Should be ignored

      // Assert
      actionCompleter.complete();
      await future1;
      await future2;

      expect(actionExecutionCount, 1);
      expect(receivedArg, "arg1"); // Ensure first argument was used
      expect(commandWithArg.running, isFalse);
      expect(commandWithArg.completed, isTrue);
      expect(commandWithArg.result!.okValue, "Delayed: arg1");
      expect(listenerCounter.count, 2);
    });
  });
*/
}
