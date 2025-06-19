import 'package:atitus_flutter_ui_layer/command.dart';
import 'package:atitus_flutter_ui_layer/data/repositories/repository.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/holiday.dart';
import 'package:atitus_flutter_ui_layer/result.dart';
import 'package:flutter/material.dart';

class HolidaysViewModel extends ChangeNotifier {
  HolidaysViewModel({required Repository repository})
    : _repository = repository {
    getHolidays = Command1<void, String>(_getHolidays);
  }

  final Repository _repository;

  List<Holiday>? _holidays;
  List<Holiday>? get holidays => _holidays;

  late Command1<void, String> getHolidays;

  Future<Result> _getHolidays(String countryCode) async {
    try {
      final result = await _repository.getHolidays(
        year: 2025,
        countryCode: countryCode,
      );
      switch (result) {
        case Ok<List<Holiday>>():
          _holidays = result.value;
        case Error<void>():
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
