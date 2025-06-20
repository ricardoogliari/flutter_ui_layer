import 'package:atitus_flutter_ui_layer/data/repositories/repository.dart';
import 'package:atitus_flutter_ui_layer/data/services/model/available_country.dart';
import 'package:atitus_flutter_ui_layer/result.dart';
import 'package:atitus_flutter_ui_layer/ui/home/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'home_screen_test.mocks.dart';

@GenerateMocks([Repository])
void main() {
  provideDummy<Result<List<AvailableCountry>>>(
    Result.ok([AvailableCountry('Brasil', 'BR')]),
  );

  group('HomeViewModel tests', () {
    test('Load bookings', () async {
      MockRepository repository = MockRepository();
      when(
        repository.getAvailableCountries(),
      ).thenAnswer((_) async => Result.ok([AvailableCountry('Brasil', 'BR')]));

      final viewModel = HomeViewModel(repository: repository);
      await viewModel.initializationDone; // Await the initialization

      expect(viewModel.availableCountries?.isNotEmpty, true);
    });
  });
}
