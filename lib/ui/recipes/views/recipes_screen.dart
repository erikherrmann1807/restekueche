import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/recipes/view_models/recipes_view_model.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key, required this.viewModel});

  final RecipesViewModel viewModel;

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {

  late TextEditingController textEditingController = TextEditingController();
  String response = '';

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (diPop, r) {
          if (!diPop) context.go(Routes.home);
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Recipes')
          ),
          body: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    const Text('Recipes'),
                    TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(),
                    ),
                    ElevatedButton(onPressed: () {
                      widget.viewModel.recipePrompt =
                          textEditingController.text;
                      widget.viewModel.loadRecipe();
                    }, child: const Text('Generate Recipe')),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(widget.viewModel.recipe?.title ?? ''),
                          Text(widget.viewModel.recipe?.duration ?? ''),
                          Text((widget.viewModel.recipe?.ingredients ?? '')
                              .toString()),
                          Text((widget.viewModel.recipe?.steps ?? '')
                              .toString()),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () => context.go(Routes.home),
                        child: const Text('Home')
                    ),
                  ],
                ),
              ),
            );
            }
          ),
        )
    );
  }
}


