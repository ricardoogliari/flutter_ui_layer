import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:atitus_flutter_ui_layer/data/services/api/api_client.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/available_country.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/holiday.dart';
import 'package:atitus_flutter_ui_layer/result.dart';

// Generate a MockClient using the Mockito package.
@GenerateMocks([http.Client])
import 'api_client_test.mocks.dart'; // Import the generated mocks

void main() {
  late APIClient apiClient;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    apiClient = APIClient(httpClient: mockHttpClient);
  });

  group('APIClient', () {
    group('getAvailableCountries', () {
      final tAvailableCountriesJson = jsonEncode([
        {'countryCode': 'US', 'name': 'United States'},
        {'countryCode': 'CA', 'name': 'Canada'},
      ]);
      final tAvailableCountriesModel = [
        AvailableCountry(countryCode: 'US', name: 'United States'),
        AvailableCountry(countryCode: 'CA', name: 'Canada'),
      ];
      final tUri = Uri.parse("https://date.nager.at/api/v3/AvailableCountries");

      test('should return Result.ok with List<AvailableCountry> on success (200)', () async {
        // Arrange
        when(mockHttpClient.get(tUri)).thenAnswer(
          (_) async => http.Response(tAvailableCountriesJson, 200),
        );
        // Act
        final result = await apiClient.getAvailableCountries();
        // Assert
        expect(result.isOk, isTrue);
        expect(result.okValue, isA<List<AvailableCountry>>());
        expect(result.okValue, equals(tAvailableCountriesModel));
        verify(mockHttpClient.get(tUri)).called(1);
      });

      test('should return Result.error on HTTP error (e.g., 404)', () async {
        // Arrange
        when(mockHttpClient.get(tUri)).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );
        // Act
        final result = await apiClient.getAvailableCountries();
        // Assert
        expect(result.isError, isTrue);
        expect(result.errorValue, isA<Exception>());
        verify(mockHttpClient.get(tUri)).called(1);
      });

      test('should return Result.error on network exception (e.g., SocketException)', () async {
        // Arrange
        final tSocketException = SocketException('Failed host lookup');
        when(mockHttpClient.get(tUri)).thenThrow(tSocketException);
        // Act
        final result = await apiClient.getAvailableCountries();
        // Assert
        expect(result.isError, isTrue);
        expect(result.errorValue, equals(tSocketException));
        verify(mockHttpClient.get(tUri)).called(1);
      });

      test('should return Result.error on malformed JSON (200 but decode fails)', () async {
        // Arrange
        when(mockHttpClient.get(tUri)).thenAnswer(
          (_) async => http.Response('{"malformed": "json"', 200), // Invalid JSON
        );
        // Act
        final result = await apiClient.getAvailableCountries();
        // Assert
        expect(result.isError, isTrue);
        expect(result.errorValue, isA<FormatException>());
        verify(mockHttpClient.get(tUri)).called(1);
      });
    });

    group('getHolidays', () {
      const tYear = 2023;
      const tCountryCode = 'US';
      final tHolidaysJson = jsonEncode([
        {
          'date': '2023-01-01',
          'localName': "New Year's Day",
          'name': "New Year's Day",
          'countryCode': 'US',
          'fixed': true,
          'global': true,
          'counties': null,
          'launchYear': null,
          'types': ['Public']
        },
        {
          'date': '2023-07-04',
          'localName': "Independence Day",
          'name': "Independence Day",
          'countryCode': 'US',
          'fixed': true,
          'global': true,
          'counties': null,
          'launchYear': null,
          'types': ['Public']
        },
      ]);
      final tHolidaysModel = [
        Holiday(
            date: DateTime.parse('2023-01-01'),
            localName: "New Year's Day",
            name: "New Year's Day",
            countryCode: 'US',
            fixed: true,
            global: true,
            counties: null,
            launchYear: null,
            types: ['Public']),
        Holiday(
            date: DateTime.parse('2023-07-04'),
            localName: "Independence Day",
            name: "Independence Day",
            countryCode: 'US',
            fixed: true,
            global: true,
            counties: null,
            launchYear: null,
            types: ['Public']),
      ];
      final tUri = Uri.parse("https://date.nager.at/api/v3/publicholidays/$tYear/$tCountryCode");

      test('should return Result.ok with List<Holiday> on success (200)', () async {
        // Arrange
        when(mockHttpClient.get(tUri)).thenAnswer(
          (_) async => http.Response(tHolidaysJson, 200),
        );
        // Act
        final result = await apiClient.getHolidays(year: tYear, countryCode: tCountryCode);
        // Assert
        expect(result.isOk, isTrue);
        expect(result.okValue, isA<List<Holiday>>());
        // Model comparison can be tricky with DateTime, ensure proper equals implementation in Holiday or compare fields
        expect(result.okValue!.length, tHolidaysModel.length);
        for (int i = 0; i < result.okValue!.length; i++) {
          expect(result.okValue![i].date, tHolidaysModel[i].date);
          expect(result.okValue![i].name, tHolidaysModel[i].name);
          expect(result.okValue![i].localName, tHolidaysModel[i].localName);
          expect(result.okValue![i].countryCode, tHolidaysModel[i].countryCode);
        }
        verify(mockHttpClient.get(tUri)).called(1);
      });

      test('should return Result.error on HTTP error (e.g., 500)', () async {
        // Arrange
        when(mockHttpClient.get(tUri)).thenAnswer(
          (_) async => http.Response('Server Error', 500),
        );
        // Act
        final result = await apiClient.getHolidays(year: tYear, countryCode: tCountryCode);
        // Assert
        expect(result.isError, isTrue);
        expect(result.errorValue, isA<Exception>());
        verify(mockHttpClient.get(tUri)).called(1);
      });

      test('should return Result.error on network exception (e.g., SocketException)', () async {
        // Arrange
        final tSocketException = SocketException('No internet');
        when(mockHttpClient.get(tUri)).thenThrow(tSocketException);
        // Act
        final result = await apiClient.getHolidays(year: tYear, countryCode: tCountryCode);
        // Assert
        expect(result.isError, isTrue);
        expect(result.errorValue, equals(tSocketException));
        verify(mockHttpClient.get(tUri)).called(1);
      });

      test('should return Result.error on malformed JSON (200 but decode fails)', () async {
        // Arrange
        when(mockHttpClient.get(tUri)).thenAnswer(
          (_) async => http.Response('[{"malformed": "json"}', 200), // Invalid JSON
        );
        // Act
        final result = await apiClient.getHolidays(year: tYear, countryCode: tCountryCode);
        // Assert
        expect(result.isError, isTrue);
        expect(result.errorValue, isA<FormatException>());
        verify(mockHttpClient.get(tUri)).called(1);
      });
    });
  });
}
