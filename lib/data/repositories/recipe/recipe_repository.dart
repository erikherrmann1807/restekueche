import 'package:restekueche/domain/models/recipe.dart';

abstract class RecipeRepository {
  Future<Recipe?> generateRecipe(String recipePrompt);
}
