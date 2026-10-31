import 'package:fujin/data/foods/food_repository.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

Future<MfpFood?> knownFood(
  String mfpFoodId, {
  required MyFitnessPalClient mfp,
  required FoodRepository foods,
}) async {
  try {
    return await mfp.foods.byId(mfpFoodId);
  } on MfpNetworkException {
    if (foods.onPhone(mfpFoodId) case final food?) return food;
    rethrow;
  }
}
