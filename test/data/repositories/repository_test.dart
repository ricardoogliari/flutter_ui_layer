import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:atitus_flutter_ui_layer/data/services/api/api_client.dart';
import 'package:atitus_flutter_ui_layer/data/repositories/repository.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/available_country.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/holiday.dart';
import 'package:atitus_flutter_ui_layer/result.dart';

// Generate a MockAPIClient using the Mockito package.
@GenerateMocks([APIClient])
import 'repository_test.mocks.dart'; // Import the generated mocks

// Helper to provide dummy results for Mockito
void provideDummyResults() {
  provideDummy<Result<List<AvailableCountry>>>(
    Result.error(Exception("dummy country error")),
  );
  provideDummy<Result<List<Holiday>>>(
    Result.error(Exception("dummy holiday error")),
  );
}

void main() {
  late RepositoryImpl repository;
  late MockAPIClient mockApiClient;

  setUp(() {
    mockApiClient = MockAPIClient();
    repository = RepositoryImpl(client: mockApiClient);
    provideDummyResults(); // Call it in setUp to ensure it's done for each test
  });

  // Dummy data
  final tAvailableCountries = [
    AvailableCountry('US', 'United States'),
    AvailableCountry('CA', 'Canada'),
  ];

  final tHolidays = [
    Holiday('', 'New Year', 'New Year', 'US'),
    Holiday('', 'Independence Day', 'Independence Day', 'US'),
  ];

  final tException = Exception('Something went wrong');
  const tYear = 2024;
  const tCountryCode = 'US';

  group('RepositoryImpl', () {
    group('getAvailableCountries', () {
      test('should return Ok result when apiClient returns Ok', () async {
        // Arrange
        when(
          mockApiClient.getAvailableCountries(),
        ).thenAnswer((_) async => Result.ok(tAvailableCountries));
        // Act
        final result = await repository.getAvailableCountries();
        // Assert
        expect(result is Ok, isTrue);
        expect((result as Ok).value, equals(tAvailableCountries));
        verify(mockApiClient.getAvailableCountries()).called(1);
      });

      test('should return Error result when apiClient returns Error', () async {
        // Arrange
        when(
          mockApiClient.getAvailableCountries(),
        ).thenAnswer((_) async => Result.error(tException));
        // Act
        final result = await repository.getAvailableCountries();
        // Assert
        expect(result is Error, isTrue);
        expect((result as Error).error, equals(tException));
        verify(mockApiClient.getAvailableCountries()).called(1);
      });

      test(
        'should return Error result when apiClient throws an exception',
        () async {
          // Arrange
          when(mockApiClient.getAvailableCountries()).thenThrow(tException);
          // Act
          final result = await repository.getAvailableCountries();
          // Assert
          expect(result is Error, isTrue);
          expect((result as Error).error, equals(tException));
          verify(mockApiClient.getAvailableCountries()).called(1);
        },
      );
    });

    group('getHolidays', () {
      test('should return Ok result when apiClient returns Ok', () async {
        // Arrange
        when(
          mockApiClient.getHolidays(year: tYear, countryCode: tCountryCode),
        ).thenAnswer((_) async => Result.ok(tHolidays));
        // Act
        final result = await repository.getHolidays(
          year: tYear,
          countryCode: tCountryCode,
        );
        // Assert
        expect(result is Ok, isTrue);
        expect((result as Ok).value, equals(tHolidays));
        verify(
          mockApiClient.getHolidays(year: tYear, countryCode: tCountryCode),
        ).called(1);
      });

      test('should return Error result when apiClient returns Error', () async {
        // Arrange
        when(
          mockApiClient.getHolidays(year: tYear, countryCode: tCountryCode),
        ).thenAnswer((_) async => Result.error(tException));
        // Act
        final result = await repository.getHolidays(
          year: tYear,
          countryCode: tCountryCode,
        );
        // Assert
        expect(result is Error, isTrue);
        expect((result as Error).error, equals(tException));
        verify(
          mockApiClient.getHolidays(year: tYear, countryCode: tCountryCode),
        ).called(1);
      });

      test(
        'should return Error result when apiClient throws an exception',
        () async {
          // Arrange
          when(
            mockApiClient.getHolidays(year: tYear, countryCode: tCountryCode),
          ).thenThrow(tException);
          // Act
          final result = await repository.getHolidays(
            year: tYear,
            countryCode: tCountryCode,
          );
          // Assert
          expect(result is Error, isTrue);
          expect((result as Error).error, equals(tException));
          verify(
            mockApiClient.getHolidays(year: tYear, countryCode: tCountryCode),
          ).called(1);
        },
      );
    });
  });
}
