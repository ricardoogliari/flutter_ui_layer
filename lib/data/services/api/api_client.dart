import 'dart:convert';
import 'package:atitus_flutter_ui_layer/data/services/model/available_country.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/holiday.dart';
import 'package:http/http.dart' as http;
import 'package:atitus_flutter_ui_layer/result.dart';

class APIClient {
  final http.Client _httpClient;
  final String _host = "https://date.nager.at/api/v3/";

  APIClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<Result<List<AvailableCountry>>> getAvailableCountries() async {
    try {
      final response = await _httpClient.get(Uri.parse('${_host}AvailableCountries'));
      if (response.statusCode == 200) {
        List myList = jsonDecode(response.body);
        return Result.ok(
          myList.map((e) => AvailableCountry.fromJson(e)).toList(),
        );
      } else {
        return Result.error(Exception());
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Holiday>>> getHolidays({
    required int year,
    required String countryCode,
  }) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${_host}publicholidays/$year/$countryCode'),
      );
      if (response.statusCode == 200) {
        List myList = jsonDecode(response.body);
        return Result.ok(myList.map((e) => Holiday.fromJson(e)).toList());
      } else {
        return Result.error(Exception());
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
