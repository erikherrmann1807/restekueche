import 'package:flutter/material.dart';
import 'package:restekueche/data/repositories/recipe/recipe_repository_impl.dart';
import 'package:restekueche/domain/models/recipe.dart';

class RecipeResultViewModel extends ChangeNotifier {
  RecipeResultViewModel({
    required RecipeRepositoryImpl recipeRepositoryImpl,
    required this.ingredients,
  }) : _recipeRepositoryImpl = recipeRepositoryImpl;

  final RecipeRepositoryImpl _recipeRepositoryImpl;

  /// The list the user confirmed on the previous screen.
  final List<String> ingredients;

  Recipe? _recipe;
  Recipe? get recipe => _recipe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadRecipe() async {
    if (ingredients.isEmpty || _isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Recipe result = await _recipeRepositoryImpl.generateRecipe(
        ingredients.join(', '),
      );
      // The service returns an empty model instead of throwing when the
      // proxy answers with a non-200, so treat that as a failure too.
      if (_isEmpty(result)) {
        _recipe = null;
        _errorMessage =
            'Es konnte kein Rezept zu diesen Zutaten erstellt werden. '
            'Versuche es mit anderen Angaben.';
      } else {
        _recipe = result;
      }
    } catch (error, stackTrace) {
      // Keep the cause greppable — the user-facing text deliberately omits it.
      debugPrint('loadRecipe failed: $error\n$stackTrace');
      _recipe = null;
      _errorMessage =
          'Das Rezept konnte nicht generiert werden. '
          'Bitte versuche es erneut.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static bool _isEmpty(Recipe recipe) =>
      recipe.title.trim().isEmpty &&
      recipe.steps.every((String step) => step.trim().isEmpty);
}
