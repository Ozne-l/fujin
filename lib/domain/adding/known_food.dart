import 'package:fujin/data/foods/food_repository.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

Future<MfpFood?> knownFood(
  String mfpFoodId, {
  required MyFitnessPalClient mfp,
  required FoodRepository foods,
}) async {
  try {
    final food = await mfp.foods.byId(mfpFoodId);
    if (food case final food?) foods.fill(food);
    return food;
  } on MfpNetworkException {
    if (foods.onPhone(mfpFoodId) case final food?) return food;
    rethrow;
  }
}
