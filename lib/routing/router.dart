import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:restekueche/data/repositories/recipe/recipe_repository_impl.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/food_scan/views/food_scan_screen.dart';
import 'package:restekueche/ui/home/views/home_Screen.dart';
import 'package:restekueche/ui/recipes/view_models/recipes_view_model.dart';

import '../ui/recipes/views/recipes_screen.dart' show RecipesScreen;


GoRouter router() => GoRouter(
  initialLocation: Routes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return const HomeScreen();
          }
      ),
      GoRoute(
          path: Routes.food_scan,
        builder: (context, state) {
            return const FoodScanScreen();
        }
      ),
      GoRoute(
          path: Routes.recipes,
          builder: (context, state) {
            final viewModel = RecipesViewModel(
                recipeRepositoryImpl: context.read(),
            );
            return RecipesScreen(viewModel: viewModel);
          }
      ),
    ]
);
