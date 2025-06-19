import 'package:atitus_flutter_ui_layer/data/services/api/api_client.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/available_country.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/holiday.dart';
import 'package:atitus_flutter_ui_layer/result.dart';

class RepositoryImpl implements Repository {
  RepositoryImpl({required APIClient client}) : _client = client;

  final APIClient _client;

  @override
  Future<Result<List<AvailableCountry>>> getAvailableCountries() async {
    try {
      final result = await _client.getAvailableCountries();
      switch (result) {
        case Error<List<AvailableCountry>>():
          return Result.error(result.error);
        case Ok<List<AvailableCountry>>():
          return Result.ok(result.value);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<List<Holiday>>> getHolidays({
    required int year,
    required String countryCode,
  }) async {
    try {
      final result = await _client.getHolidays(
        countryCode: countryCode,
        year: year,
      );
      switch (result) {
        case Error<List<Holiday>>():
          return Result.error(result.error);
        case Ok<List<Holiday>>():
          return Result.ok(result.value);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}

abstract class Repository {
  Future<Result<List<AvailableCountry>>> getAvailableCountries();
  Future<Result<List<Holiday>>> getHolidays({
    required int year,
    required String countryCode,
  });
}
