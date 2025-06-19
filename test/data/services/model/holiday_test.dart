import 'package:flutter_test/flutter_test.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/holiday.dart';

void main() {
  group('Holiday.fromJson', () {
    test('should correctly parse JSON into a Holiday object with all fields', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'date': '2024-07-04',
        'localName': 'Independence Day',
        'name': 'Independence Day',
        'countryCode': 'US',
        'fixed': true,
        'global': true,
        'counties': ['US-VA', 'US-CA'],
        'launchYear': 2000,
        'types': ['Public', 'National'],
      };

      // Act
      final holiday = Holiday.fromJson(jsonMap);

      // Assert
      expect(holiday.date, DateTime.parse('2024-07-04'));
      expect(holiday.localName, 'Independence Day');
      expect(holiday.name, 'Independence Day');
      expect(holiday.countryCode, 'US');
      expect(holiday.fixed, isTrue);
      expect(holiday.global, isTrue);
      expect(holiday.counties, equals(['US-VA', 'US-CA']));
      expect(holiday.launchYear, 2000);
      expect(holiday.types, equals(['Public', 'National']));
    });

    test('should handle null values for nullable fields (counties, launchYear)', () {
      // Arrange
      final Map<String, dynamic> jsonMapWithNulls = {
        'date': '2024-01-01',
        'localName': "New Year's Day",
        'name': "New Year's Day",
        'countryCode': 'GB',
        'fixed': false,
        'global': true,
        'counties': null, // Nullable
        'launchYear': null, // Nullable
        'types': ['Public'],
      };

      // Act
      final holiday = Holiday.fromJson(jsonMapWithNulls);

      // Assert
      expect(holiday.date, DateTime.parse('2024-01-01'));
      expect(holiday.localName, "New Year's Day");
      expect(holiday.name, "New Year's Day");
      expect(holiday.countryCode, 'GB');
      expect(holiday.fixed, isFalse);
      expect(holiday.global, isTrue);
      expect(holiday.counties, isNull);
      expect(holiday.launchYear, isNull);
      expect(holiday.types, equals(['Public']));
    });

    test('should handle empty list for counties if provided as such', () {
          // Arrange
          final Map<String, dynamic> jsonMapEmptyCounties = {
            'date': '2024-05-01',
            'localName': 'Labour Day',
            'name': 'Labour Day',
            'countryCode': 'FR',
            'fixed': true,
            'global': true,
            'counties': [], // Empty list
            'launchYear': null,
            'types': ['Public'],
          };

          // Act
          final holiday = Holiday.fromJson(jsonMapEmptyCounties);
          // Assert
          expect(holiday.counties, isEmpty);
    });
  });

  group('Holiday equality', () {
    final holiday1 = Holiday(
      date: DateTime.parse('2024-12-25'),
      localName: 'Christmas Day',
      name: 'Christmas Day',
      countryCode: 'UK',
      fixed: true,
      global: true,
      counties: null,
      launchYear: null,
      types: ['Public', 'Christian'],
    );

    final holiday1Copy = Holiday(
      date: DateTime.parse('2024-12-25'),
      localName: 'Christmas Day',
      name: 'Christmas Day',
      countryCode: 'UK',
      fixed: true,
      global: true,
      counties: null,
      launchYear: null,
      types: ['Public', 'Christian'],
    );

    final holiday2 = Holiday(
      date: DateTime.parse('2024-01-01'),
      localName: "New Year's Day",
      name: "New Year's Day",
      countryCode: 'UK',
      fixed: true,
      global: true,
      counties: null,
      launchYear: null,
      types: ['Public'],
    );

    test('two instances with the same properties should be equal', () {
      expect(holiday1, equals(holiday1Copy));
    });

    test('two instances with different properties should not be equal', () {
      expect(holiday1, isNot(equals(holiday2)));
    });

     test('instances with different list content for types should not be equal', () {
      final holiday3 = Holiday(
        date: DateTime.parse('2024-12-25'),
        localName: 'Christmas Day',
        name: 'Christmas Day',
        countryCode: 'UK',
        fixed: true,
        global: true,
        counties: null,
        launchYear: null,
        types: ['Public'], // Different from holiday1
      );
      expect(holiday1, isNot(equals(holiday3)));
    });

    test('instances with different list content for counties should not be equal', () {
      final holidayWithCounties = Holiday(
        date: DateTime.parse('2024-12-25'),
        localName: 'Christmas Day',
        name: 'Christmas Day',
        countryCode: 'UK',
        fixed: true,
        global: true,
        counties: ['County1'], // Different from holiday1 which has null counties
        launchYear: null,
        types: ['Public', 'Christian'],
      );
      expect(holiday1, isNot(equals(holidayWithCounties)));
    });
  });
}
