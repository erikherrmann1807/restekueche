import 'package:image_picker/image_picker.dart';
import 'package:restekueche/data/model/detected_ingredient_model.dart';
import 'package:restekueche/data/repositories/ingredient/ingredient_repository.dart';
import 'package:restekueche/data/services/vision_service.dart';
import 'package:restekueche/domain/models/detected_ingredient.dart';
import 'package:restekueche/utils/image_compressor.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  IngredientRepositoryImpl({required VisionService visionService})
    : _visionService = visionService;

  final VisionService _visionService;

  @override
  Future<List<DetectedIngredient>> detectIngredients(XFile photo) async {
    final CompressedImage image = await compressForVision(photo);
    final List<DetectedIngredientModel> detected =
        await _visionService.detectIngredients(image);

    return detected
        .map(
          (DetectedIngredientModel model) => DetectedIngredient(
            name: model.name,
            confidence: model.confidence,
          ),
        )
        .toList();
  }
}
