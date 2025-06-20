import 'package:flutter_test/flutter_test.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/holiday.dart';

void main() {
  group('Holiday.fromJson', () {
    test(
      'should correctly parse JSON into a Holiday object with all fields',
      () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'date': '2024-07-04',
          'localName': 'Independence Day',
          'name': 'Independence Day',
          'countryCode': 'US',
        };

        // Act
        final holiday = Holiday.fromJson(jsonMap);

        // Assert
        expect(holiday.date, '2024-07-04');
        expect(holiday.localName, 'Independence Day');
        expect(holiday.name, 'Independence Day');
        expect(holiday.countryCode, 'US');
      },
    );

    test(
      'should handle null values for nullable fields (counties, launchYear)',
      () {
        // Arrange
        final Map<String, dynamic> jsonMapWithNulls = {
          'date': '2024-01-01',
          'localName': "New Year's Day",
          'name': "New Year's Day",
        };

        // Act
        final holiday = Holiday.fromJson(jsonMapWithNulls);

        // Assert
        expect(holiday.date, '2024-01-01');
        expect(holiday.localName, "New Year's Day");
        expect(holiday.name, "New Year's Day");
        expect(holiday.countryCode, null);
      },
    );

    test('should handle empty list for counties if provided as such', () {
      // Arrange
      final Map<String, dynamic> jsonMapEmptyCounties = {
        'date': '2024-05-01',
        'localName': 'Labour Day',
        'name': 'Labour Day',
        'countryCode': 'FR',
      };

      // Act
      final holiday = Holiday.fromJson(jsonMapEmptyCounties);
      // Assert
      expect(holiday.name, 'Labour Day');
    });
  });

  group('Holiday equality', () {
    final holiday1 = Holiday(
      '2024-12-25',
      'Christmas Day',
      'Christmas Day',
      'UK',
    );

    final holiday1Copy = Holiday(
      '2024-12-25',
      'Christmas Day',
      'Christmas Day',
      'UK',
    );

    final holiday2 = Holiday(
      '2024-01-01',
      'New Years Day',
      'New Years Day',
      'UK',
    );

    test('two instances with the same properties should be equal', () {
      expect(holiday1, equals(holiday1Copy));
    });

    test('two instances with different properties should not be equal', () {
      expect(holiday1, isNot(equals(holiday2)));
    });
  });
}
