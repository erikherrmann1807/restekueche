import 'package:go_router/go_router.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/food_scan/views/food_scan_screen.dart';
import 'package:restekueche/ui/home/views/home_Screen.dart';

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
            return const RecipesScreen();
          }
      ),
    ]
);
