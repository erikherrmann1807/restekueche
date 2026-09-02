import 'package:image_picker/image_picker.dart';
import 'package:restekueche/domain/models/detected_ingredient.dart';

abstract class IngredientRepository {
  Future<List<DetectedIngredient>> detectIngredients(XFile photo);
}
