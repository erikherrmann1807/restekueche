import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restekueche/data/repositories/recipe/recipe_repository_impl.dart';
import 'package:restekueche/data/services/recipe_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider.value(value: RecipeService()),
    Provider(
      create: (context) =>
          RecipeRepositoryImpl(recipeService: context.read()),
    ),
  ];
}
