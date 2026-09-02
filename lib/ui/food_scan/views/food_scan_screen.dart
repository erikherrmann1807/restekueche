import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/core/widgets/centered_hint.dart';
import 'package:restekueche/ui/food_scan/view_models/food_scan_view_model.dart';

class FoodScanScreen extends StatefulWidget {
  const FoodScanScreen({super.key, required this.viewModel});

  final FoodScanViewModel viewModel;

  @override
  State<FoodScanScreen> createState() => _FoodScanScreenState();
}

class _FoodScanScreenState extends State<FoodScanScreen> {
  Future<void> _scan(ImageSource source) async {
    final IngredientDetection? detection = await widget.viewModel.pickPhoto(
      source,
    );
    if (detection == null || !mounted) {
      return;
    }
    await context.push(Routes.ingredient_confirm, extra: detection);
    // Coming back from the confirmation screen should offer a fresh start
    // rather than the stale photo of the previous run.
    widget.viewModel.reset();
  }

  void _continueWithoutPhoto() {
    context.push(
      Routes.ingredient_confirm,
      extra: const IngredientDetection(photo: null, ingredients: []),
    );
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
          title: const Text('Lebensmittel scannen'),
        ),
        body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: _buildBody(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (widget.viewModel.isDetecting) {
      return _DetectingState(photo: widget.viewModel.photo);
    }

    final String? errorMessage = widget.viewModel.errorMessage;
    if (errorMessage != null) {
      return CenteredHint(
        icon: Icons.error_outline,
        message: errorMessage,
        color: theme.colorScheme.error,
        action: FilledButton.tonalIcon(
          onPressed: widget.viewModel.reset,
          icon: const Icon(Icons.refresh),
          label: const Text('Erneut versuchen'),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.photo_camera_outlined,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Fotografiere, was du da hast — die KI schlägt dir daraus ein '
          'Rezept vor.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: () => _scan(ImageSource.camera),
          icon: const Icon(Icons.photo_camera),
          label: const Text('Foto aufnehmen'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _scan(ImageSource.gallery),
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Aus Galerie wählen'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _continueWithoutPhoto,
          child: const Text('Ohne Foto weiter'),
        ),
      ],
    );
  }
}

class _DetectingState extends StatelessWidget {
  const _DetectingState({required this.photo});

  final XFile? photo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (photo != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(photo!.path),
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 24),
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Zutaten werden erkannt…',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
