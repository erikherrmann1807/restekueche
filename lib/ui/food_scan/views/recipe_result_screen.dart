import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restekueche/domain/models/recipe.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/core/widgets/centered_hint.dart';
import 'package:restekueche/ui/core/widgets/recipe_view.dart';
import 'package:restekueche/ui/food_scan/view_models/recipe_result_view_model.dart';

class RecipeResultScreen extends StatefulWidget {
  const RecipeResultScreen({super.key, required this.viewModel});

  final RecipeResultViewModel viewModel;

  @override
  State<RecipeResultScreen> createState() => _RecipeResultScreenState();
}

class _RecipeResultScreenState extends State<RecipeResultScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Rezeptvorschlag'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: _buildResult(context),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextButton.icon(
            onPressed: () => context.go(Routes.food_scan),
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Neues Foto'),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (widget.viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final String? errorMessage = widget.viewModel.errorMessage;
    if (errorMessage != null) {
      return CenteredHint(
        icon: Icons.error_outline,
        message: errorMessage,
        color: theme.colorScheme.error,
        action: FilledButton.tonalIcon(
          onPressed: widget.viewModel.loadRecipe,
          icon: const Icon(Icons.refresh),
          label: const Text('Erneut versuchen'),
        ),
      );
    }

    final Recipe? recipe = widget.viewModel.recipe;
    if (recipe == null) {
      return CenteredHint(
        icon: Icons.restaurant_menu,
        message: 'Noch kein Rezept vorhanden.',
        color: theme.colorScheme.outline,
      );
    }

    return SingleChildScrollView(child: RecipeView(recipe: recipe));
  }
}
