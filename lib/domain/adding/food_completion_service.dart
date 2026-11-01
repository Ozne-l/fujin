import 'package:fujin/data/foods/food_repository.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class FoodCompletionService {
  FoodCompletionService({required this._mfp, required this._foods});

  final MyFitnessPalClient _mfp;
  final FoodRepository _foods;
  Future<void>? _running;

  Future<void> complete() =>
      _running ??= _completeAll().whenComplete(() => _running = null);

  Future<void> _completeAll() async {
    for (final mfpFoodId in _foods.mfpFoodsWithoutServings()) {
      try {
        if (await _mfp.foods.byId(mfpFoodId) case final food?) {
          _foods.fill(food);
        }
      } on MfpException catch (error) {
        switch (error) {
          case MfpNetworkException() || MfpAuthException():
            return;
          case MfpApiException() ||
              MfpUnexpectedResponseException() ||
              MfpBarcodeException():
            break;
        }
      }
    }
  }
}
