import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restekueche/routing/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Restekueche'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: () => context.go(Routes.food_scan),
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Lebensmittel scannen'),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => context.go(Routes.recipes),
              icon: const Icon(Icons.bookmark_border),
              label: const Text('Meine Rezepte'),
            ),
          ],
        ),
      ),
    );
  }
}
