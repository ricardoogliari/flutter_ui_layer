import 'package:atitus_flutter_ui_layer/command.dart';
import 'package:atitus_flutter_ui_layer/data/repositories/repository.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/available_country.dart';
import 'package:atitus_flutter_ui_layer/result.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  late Future<void> initializationDone;

  HomeViewModel({required Repository repository}) : _repository = repository {
    getAvailableCountries = Command0(_getAvailableCountries);
    initializationDone = getAvailableCountries.execute();
  }

  final Repository _repository;

  List<AvailableCountry>? _availableCountries;
  List<AvailableCountry>? get availableCountries => _availableCountries;

  late Command0 getAvailableCountries;

  Future<Result> _getAvailableCountries() async {
    try {
      final result = await _repository.getAvailableCountries();
      switch (result) {
        case Ok<List<AvailableCountry>>():
          _availableCountries = result.value;
        case Error<void>():
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
