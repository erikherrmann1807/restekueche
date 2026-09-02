import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/food_scan/view_models/food_scan_view_model.dart';
import 'package:restekueche/ui/food_scan/view_models/ingredient_confirm_view_model.dart';
import 'package:restekueche/ui/food_scan/view_models/recipe_result_view_model.dart';
import 'package:restekueche/ui/food_scan/views/food_scan_screen.dart';
import 'package:restekueche/ui/food_scan/views/ingredient_confirm_screen.dart';
import 'package:restekueche/ui/food_scan/views/recipe_result_screen.dart';
import 'package:restekueche/ui/home/views/home_screen.dart';
import 'package:restekueche/ui/recipes/views/recipes_screen.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: Routes.food_scan,
      builder: (context, state) {
        return FoodScanScreen(
          viewModel: FoodScanViewModel(
            ingredientRepositoryImpl: context.read(),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.ingredient_confirm,
      // `extra` does not survive a hot restart or a deep link, so the
      // detection can legitimately be missing here.
      redirect: (context, state) =>
          state.extra is IngredientDetection ? null : Routes.food_scan,
      builder: (context, state) {
        final detection = state.extra! as IngredientDetection;
        return IngredientConfirmScreen(
          photo: detection.photo,
          viewModel: IngredientConfirmViewModel(
            detected: detection.ingredients,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.recipe_result,
      redirect: (context, state) =>
          state.extra is List<String> ? null : Routes.food_scan,
      builder: (context, state) {
        final ingredients = state.extra! as List<String>;
        return RecipeResultScreen(
          viewModel: RecipeResultViewModel(
            recipeRepositoryImpl: context.read(),
            ingredients: ingredients,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.recipes,
      builder: (context, state) {
        return const RecipesScreen();
      },
    ),
  ],
);
