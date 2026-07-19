import 'package:flutter/material.dart';
import 'package:restekueche/data/repositories/recipe/recipe_repository_impl.dart';
import 'package:restekueche/domain/models/recipe.dart';

class RecipesViewModel extends ChangeNotifier{
  RecipesViewModel({
    required RecipeRepositoryImpl recipeRepositoryImpl
  }) :
        _recipeRepositoryImpl = recipeRepositoryImpl;
  final RecipeRepositoryImpl _recipeRepositoryImpl;
  String recipePrompt = '';
  Recipe? recipe;

  Future<void> loadRecipe() async {
    recipe = await _recipeRepositoryImpl.generateRecipe(recipePrompt);
    print(recipe!.title);
    notifyListeners();
  }
}
