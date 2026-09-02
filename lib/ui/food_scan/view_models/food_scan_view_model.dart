import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restekueche/data/repositories/ingredient/ingredient_repository_impl.dart';
import 'package:restekueche/domain/models/detected_ingredient.dart';

/// What the scan screen hands over to the confirmation screen.
class IngredientDetection {
  const IngredientDetection({required this.photo, required this.ingredients});

  final XFile? photo;
  final List<DetectedIngredient> ingredients;
}

class FoodScanViewModel extends ChangeNotifier {
  FoodScanViewModel({
    required IngredientRepositoryImpl ingredientRepositoryImpl,
    ImagePicker? imagePicker,
  }) : _ingredientRepositoryImpl = ingredientRepositoryImpl,
       _imagePicker = imagePicker ?? ImagePicker();

  final IngredientRepositoryImpl _ingredientRepositoryImpl;
  final ImagePicker _imagePicker;

  XFile? _photo;
  XFile? get photo => _photo;

  bool _isDetecting = false;
  bool get isDetecting => _isDetecting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  IngredientDetection? _detection;
  IngredientDetection? get detection => _detection;

  /// Takes or picks a photo and runs the recognition on it.
  ///
  /// Returns the result so the screen can navigate on; null means there is
  /// nothing to navigate to yet, either because the user backed out of the
  /// picker or because the request failed.
  Future<IngredientDetection?> pickPhoto(ImageSource source) async {
    if (_isDetecting) {
      return null;
    }

    final XFile? picked;
    try {
      picked = await _imagePicker.pickImage(source: source);
    } catch (error, stackTrace) {
      debugPrint('pickImage failed: $error\n$stackTrace');
      _errorMessage =
          'Auf die Kamera bzw. die Galerie konnte nicht zugegriffen '
          'werden. Prüfe die Berechtigungen in den Einstellungen.';
      notifyListeners();
      return null;
    }

    // The user backed out of the camera or gallery — not a failure.
    if (picked == null) {
      return null;
    }

    _photo = picked;
    _isDetecting = true;
    _errorMessage = null;
    _detection = null;
    notifyListeners();

    try {
      final List<DetectedIngredient> ingredients =
          await _ingredientRepositoryImpl.detectIngredients(picked);
      _detection = IngredientDetection(
        photo: picked,
        ingredients: ingredients,
      );
      return _detection;
    } catch (error, stackTrace) {
      // Keep the cause greppable — the user-facing text deliberately omits it.
      debugPrint('detectIngredients failed: $error\n$stackTrace');
      _errorMessage =
          'Das Foto konnte nicht ausgewertet werden. '
          'Bitte versuche es erneut.';
      return null;
    } finally {
      _isDetecting = false;
      notifyListeners();
    }
  }

  /// Drops the current photo and error so the screen shows its start state.
  void reset() {
    _photo = null;
    _detection = null;
    _errorMessage = null;
    notifyListeners();
  }
}
