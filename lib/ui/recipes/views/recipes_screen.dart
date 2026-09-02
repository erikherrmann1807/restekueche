import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/recipes/view_models/recipes_view_model.dart';
import 'package:restekueche/ui/recipes/widgets/recipe_view.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key, required this.viewModel});

  final RecipesViewModel viewModel;

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _generateRecipe() {
    widget.viewModel.recipePrompt = textEditingController.text;
    widget.viewModel.loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (diPop, r) {
        if (!diPop) {
          context.go(Routes.home);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Recipes'),
        ),
        body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            final bool isLoading = widget.viewModel.isLoading;

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: textEditingController,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _generateRecipe(),
                    decoration: const InputDecoration(
                      labelText: 'Lebensmittel',
                      hintText: 'z. B. Reis, Huhn, Ei',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.kitchen_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _generateRecipe,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate Recipe'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildResult(context)),
                  TextButton(
                    onPressed: () => context.go(Routes.home),
                    child: const Text('Home'),
                  ),
                ],
              ),
            );
          },
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
      return _CenteredHint(
        icon: Icons.error_outline,
        message: errorMessage,
        color: theme.colorScheme.error,
      );
    }

    final recipe = widget.viewModel.recipe;
    if (recipe == null) {
      return _CenteredHint(
        icon: Icons.restaurant_menu,
        message:
            'Gib deine Lebensmittel ein und lass dir ein Rezept '
            'vorschlagen.',
        color: theme.colorScheme.outline,
      );
    }

    return SingleChildScrollView(child: RecipeView(recipe: recipe));
  }
}

class _CenteredHint extends StatelessWidget {
  const _CenteredHint({
    required this.icon,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
