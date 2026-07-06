import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restekueche/routing/routes.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Recipes')
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: PopScope(
            canPop: false,
              onPopInvokedWithResult: (diPop, r) {
              if (diPop) {
                return;
              }
              context.go(Routes.home);
              },
              child: Column(
                children: [
                  Text('Recipes'),
                  TextButton(
                      onPressed: () => context.go(Routes.home),
                      child: const Text('Home')
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
