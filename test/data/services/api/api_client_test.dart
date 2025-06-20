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
        AvailableCountry('US', 'United States'),
        AvailableCountry('CA', 'Canada'),
      ];
      final tUri = Uri.parse("https://date.nager.at/api/v3/AvailableCountries");

      test(
        'should return Result.ok with List<AvailableCountry> on success (200)',
        () async {
          // Arrange
          when(mockHttpClient.get(tUri)).thenAnswer(
            (_) async => http.Response(tAvailableCountriesJson, 200),
          );
          // Act
          final result = await apiClient.getAvailableCountries();
          // Assert
          expect(result is Ok, isTrue);
          expect((result as Ok).value, isA<List<AvailableCountry>>());
          expect((result as Ok).value, equals(tAvailableCountriesModel));
          verify(mockHttpClient.get(tUri)).called(1);
        },
      );

      test('should return Result.error on HTTP error (e.g., 404)', () async {
        // Arrange
        when(
          mockHttpClient.get(tUri),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // Act
        final result = await apiClient.getAvailableCountries();
        // Assert
        expect(result is Error, isTrue);
        expect((result as Error).error, isA<Exception>());
        verify(mockHttpClient.get(tUri)).called(1);
      });

      test(
        'should return Result.error on network exception (e.g., SocketException)',
        () async {
          // Arrange
          final tSocketException = SocketException('Failed host lookup');
          when(mockHttpClient.get(tUri)).thenThrow(tSocketException);
          // Act
          final result = await apiClient.getAvailableCountries();
          // Assert
          expect(result is Error, isTrue);
          expect((result as Error).error, equals(tSocketException));
          verify(mockHttpClient.get(tUri)).called(1);
        },
      );

      test(
        'should return Result.error on malformed JSON (200 but decode fails)',
        () async {
          // Arrange
          when(mockHttpClient.get(tUri)).thenAnswer(
            (_) async =>
                http.Response('{"malformed": "json"', 200), // Invalid JSON
          );
          // Act
          final result = await apiClient.getAvailableCountries();
          // Assert
          expect(result is Error, isTrue);
          expect((result as Error).error, isA<FormatException>());
          verify(mockHttpClient.get(tUri)).called(1);
        },
      );
    });

    group('getHolidays', () {
      const tYear = 2023;
      const tCountryCode = 'US';
      final tHolidaysJson = jsonEncode([
        {
          'date': '2023-01-01',
          'localName': 'New Years Day',
          'name': 'New Years Day',
          'countryCode': 'US',
        },
        {
          'date': '2023-07-04',
          'localName': 'Independence Day',
          'name': 'Independence Day',
          'countryCode': 'US',
        },
      ]);
      final tHolidaysModel = [
        Holiday('2023-01-01', 'New Years Day', 'New Years Day', 'US'),
        Holiday('2023-07-04', 'Independence Day', 'Independence Day', 'US'),
      ];
      final tUri = Uri.parse(
        "https://date.nager.at/api/v3/publicholidays/$tYear/$tCountryCode",
      );

      test(
        'should return Result.ok with List<Holiday> on success (200)',
        () async {
          // Arrange
          when(
            mockHttpClient.get(tUri),
          ).thenAnswer((_) async => http.Response(tHolidaysJson, 200));
          // Act
          final result = await apiClient.getHolidays(
            year: tYear,
            countryCode: tCountryCode,
          );
          // Assert
          expect(result is Ok, isTrue);
          expect((result as Ok).value, isA<List<Holiday>>());
          // Model comparison can be tricky with DateTime, ensure proper equals implementation in Holiday or compare fields
          expect((result as Ok).value.length, tHolidaysModel.length);
          for (int i = 0; i < (result as Ok).value.length; i++) {
            expect((result as Ok).value[i].date, tHolidaysModel[i].date);
            expect((result as Ok).value[i].name, tHolidaysModel[i].name);
            expect(
              (result as Ok).value[i].localName,
              tHolidaysModel[i].localName,
            );
            expect(
              (result as Ok).value[i].countryCode,
              tHolidaysModel[i].countryCode,
            );
          }
          verify(mockHttpClient.get(tUri)).called(1);
        },
      );

      test('should return Result.error on HTTP error (e.g., 500)', () async {
        // Arrange
        when(
          mockHttpClient.get(tUri),
        ).thenAnswer((_) async => http.Response('Server Error', 500));
        // Act
        final result = await apiClient.getHolidays(
          year: tYear,
          countryCode: tCountryCode,
        );
        // Assert
        expect(result is Error, isTrue);
        expect((result as Error).error, isA<Exception>());
        verify(mockHttpClient.get(tUri)).called(1);
      });

      test(
        'should return Result.error on network exception (e.g., SocketException)',
        () async {
          // Arrange
          final tSocketException = SocketException('No internet');
          when(mockHttpClient.get(tUri)).thenThrow(tSocketException);
          // Act
          final result = await apiClient.getHolidays(
            year: tYear,
            countryCode: tCountryCode,
          );
          // Assert
          expect(result is Error, isTrue);
          expect((result as Error).error, equals(tSocketException));
          verify(mockHttpClient.get(tUri)).called(1);
        },
      );

      test(
        'should return Result.error on malformed JSON (200 but decode fails)',
        () async {
          // Arrange
          when(mockHttpClient.get(tUri)).thenAnswer(
            (_) async =>
                http.Response('[{"malformed": "json"}', 200), // Invalid JSON
          );
          // Act
          final result = await apiClient.getHolidays(
            year: tYear,
            countryCode: tCountryCode,
          );
          // Assert
          expect(result is Error, isTrue);
          expect((result as Error).error, isA<FormatException>());
          verify(mockHttpClient.get(tUri)).called(1);
        },
      );
    });
  });
}
