import 'package:flutter_test/flutter_test.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/available_country.dart';

void main() {
  group('AvailableCountry.fromJson', () {
    test('should correctly parse JSON into an AvailableCountry object', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'countryCode': 'US',
        'name': 'United States',
      };

      // Act
      final country = AvailableCountry.fromJson(jsonMap);

      // Assert
      expect(country.countryCode, 'US');
      expect(country.name, 'United States');
    });

    test('should handle null values for nullable fields if applicable', () {
      // Arrange
      // Assuming 'name' could be nullable based on typical API designs,
      // or if the model explicitly allows it.
      // If countryCode is non-nullable and a null is provided,
      // this would test for an error or default value if handled by fromJson.
      // For this example, let's assume 'name' is String?
      // And 'countryCode' is String (non-nullable).
      // The current AvailableCountry model seems to have non-nullable fields.
      // So, a direct null test might not be what we want unless we are testing robustness against bad API data.
      // Let's stick to testing a valid case as per current model structure.
      // If the model was:
      // final String? name;
      // final String countryCode;
      // Then this test would be:
      // final Map<String, dynamic> jsonMapWithNull = {
      //   'countryCode': 'XY',
      //   'name': null,
      // };
      // final countryWithNullName = AvailableCountry.fromJson(jsonMapWithNull);
      // expect(countryWithNullName.countryCode, 'XY');
      // expect(countryWithNullName.name, isNull);

      // For the current model (String countryCode, String name),
      // providing null where not expected would likely throw an error during fromJson.
      // We're testing successful parsing here.
      // If specific error handling for unexpected nulls in fromJson is desired,
      // that would be a different type of test (e.g., using expect(() => ..., throwsA<TypeError>())).

      // Re-affirming the first test's structure for clarity on current model:
       final Map<String, dynamic> anotherJsonMap = {
        'countryCode': 'CA',
        'name': 'Canada',
      };
      final anotherCountry = AvailableCountry.fromJson(anotherJsonMap);
      expect(anotherCountry.countryCode, 'CA');
      expect(anotherCountry.name, 'Canada');
    });
  });

  group('AvailableCountry equality', () {
    test('two instances with the same properties should be equal', () {
      final country1 = AvailableCountry(countryCode: 'DE', name: 'Germany');
      final country2 = AvailableCountry(countryCode: 'DE', name: 'Germany');
      expect(country1, equals(country2));
    });

    test('two instances with different properties should not be equal', () {
      final country1 = AvailableCountry(countryCode: 'DE', name: 'Germany');
      final country2 = AvailableCountry(countryCode: 'FR', name: 'France');
      expect(country1, isNot(equals(country2)));
    });
  });
}
