import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/core/widgets/centered_hint.dart';

/// Placeholder for the saved recipes of phase 3 — recipes are generated in
/// the scan flow and not persisted yet.
class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (diPop, r) {
        if (!diPop) {
          context.go(Routes.home);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.inversePrimary,
          title: const Text('Meine Rezepte'),
        ),
        body: CenteredHint(
          icon: Icons.bookmark_border,
          message:
              'Noch keine gespeicherten Rezepte. Scanne deine Lebensmittel '
              'und speichere dein erstes Rezept.',
          color: theme.colorScheme.outline,
          action: FilledButton.tonalIcon(
            onPressed: () => context.go(Routes.food_scan),
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Lebensmittel scannen'),
          ),
        ),
      ),
    );
  }
}
