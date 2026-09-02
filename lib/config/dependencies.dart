import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restekueche/data/repositories/ingredient/ingredient_repository_impl.dart';
import 'package:restekueche/data/repositories/recipe/recipe_repository_impl.dart';
import 'package:restekueche/data/services/recipe_service.dart';
import 'package:restekueche/data/services/vision_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider.value(value: RecipeService()),
    Provider.value(value: VisionService()),
    Provider(
      create: (context) =>
          RecipeRepositoryImpl(recipeService: context.read()),
    ),
    Provider(
      create: (context) =>
          IngredientRepositoryImpl(visionService: context.read()),
    ),
  ];
}
