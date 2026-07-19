import 'package:restekueche/data/repositories/recipe/recipe_repository.dart';
import 'package:restekueche/data/services/recipe_service.dart';
import 'package:restekueche/domain/models/recipe.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl({required RecipeService recipeService})
  : _recipeService = recipeService;

  final RecipeService _recipeService;

  @override
  Future<Recipe> generateRecipe(String recipePrompt) async {
    final recipe = await _recipeService.generateRecipe(recipePrompt);
    return Recipe(
        title: recipe.title,
        ingredients: recipe.ingredients,
        steps: recipe.steps,
        duration: recipe.duration
    );
  }

}
