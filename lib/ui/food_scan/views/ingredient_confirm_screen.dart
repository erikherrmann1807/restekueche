import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restekueche/routing/routes.dart';
import 'package:restekueche/ui/core/widgets/centered_hint.dart';
import 'package:restekueche/ui/food_scan/view_models/ingredient_confirm_view_model.dart';

/// Lets the user correct what the model saw before a recipe is built on it.
///
/// The screen deliberately never presents the detection as settled: shaky
/// guesses arrive unchecked, every row can be renamed or deleted, and a
/// missed ingredient can be typed in.
class IngredientConfirmScreen extends StatefulWidget {
  const IngredientConfirmScreen({
    super.key,
    required this.viewModel,
    this.photo,
  });

  final IngredientConfirmViewModel viewModel;
  final XFile? photo;

  @override
  State<IngredientConfirmScreen> createState() =>
      _IngredientConfirmScreenState();
}

class _IngredientConfirmScreenState extends State<IngredientConfirmScreen> {
  final TextEditingController _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    widget.viewModel.add(_addController.text);
    _addController.clear();
  }

  Future<void> _renameIngredient(int index, String currentName) async {
    final String? renamed = await showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          _RenameDialog(initialName: currentName),
    );

    if (renamed != null) {
      widget.viewModel.rename(index, renamed);
    }
  }

  void _generateRecipe() {
    context.push(
      Routes.recipe_result,
      extra: widget.viewModel.confirmedIngredients,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Zutaten prüfen'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              if (widget.photo != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(widget.photo!.path),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (widget.viewModel.hasDetections) ...[
                const _UncertaintyBanner(),
                const SizedBox(height: 8),
              ],
              ..._buildIngredientRows(context),
              const SizedBox(height: 8),
              _AddIngredientRow(
                controller: _addController,
                onSubmit: _addIngredient,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          final int count = widget.viewModel.selectedCount;
          final String unit = count == 1 ? 'Zutat' : 'Zutaten';

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: count == 0 ? null : _generateRecipe,
                icon: const Icon(Icons.auto_awesome),
                label: Text(
                  count == 0
                      ? 'Mindestens eine Zutat wählen'
                      : '$count $unit - Rezept generieren',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildIngredientRows(BuildContext context) {
    final List<EditableIngredient> ingredients = widget.viewModel.ingredients;

    if (ingredients.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: CenteredHint(
            icon: Icons.no_food_outlined,
            message: widget.photo == null
                ? 'Trag deine Zutaten von Hand ein.'
                : 'Auf dem Foto war nichts Essbares zu erkennen. '
                      'Trag deine Zutaten von Hand ein oder mach ein '
                      'neues Foto.',
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ];
    }

    return [
      for (final (int index, EditableIngredient ingredient)
          in ingredients.indexed)
        _IngredientRow(
          ingredient: ingredient,
          onToggle: () => widget.viewModel.toggle(index),
          onRename: () => _renameIngredient(index, ingredient.name),
          onRemove: () => widget.viewModel.remove(index),
        ),
    ];
  }
}

/// Owns its text controller so it outlives the dialog's exit animation.
///
/// Disposing a controller straight after `showDialog` returns kills it while
/// the route is still fading out and the [TextField] is still rebuilding.
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initialName});

  final String initialName;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zutat umbenennen'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onSubmitted: (String value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Übernehmen'),
        ),
      ],
    );
  }
}

class _UncertaintyBanner extends StatelessWidget {
  const _UncertaintyBanner();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Das ist nur ein Vorschlag der KI — sie liegt auch mal '
              'daneben. Streiche, was nicht stimmt, und ergänze, was '
              'fehlt.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.ingredient,
    required this.onToggle,
    required this.onRename,
    required this.onRemove,
  });

  final EditableIngredient ingredient;
  final VoidCallback onToggle;
  final VoidCallback onRename;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool uncertain = ingredient.isUncertain;
    final Color nameColor = uncertain
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.onSurface;

    return Row(
      children: [
        Checkbox(value: ingredient.selected, onChanged: (_) => onToggle()),
        Expanded(
          child: InkWell(
            onTap: onRename,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      ingredient.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: nameColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (uncertain) ...[
                    const SizedBox(width: 8),
                    Text(
                      'unsicher',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        _ConfidenceDots(confidence: ingredient.confidence),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.close, size: 20),
          color: theme.colorScheme.outline,
          tooltip: 'Entfernen',
        ),
      ],
    );
  }
}

/// Three dots standing in for the model's confidence.
///
/// A raw percentage would suggest a precision the model does not have —
/// coarse buckets are honest about how rough the number is.
class _ConfidenceDots extends StatelessWidget {
  const _ConfidenceDots({required this.confidence});

  final double confidence;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int filled = (confidence * 3).ceil().clamp(1, 3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Icon(
              i < filled ? Icons.circle : Icons.circle_outlined,
              size: 8,
              color: i < filled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
      ],
    );
  }
}

class _AddIngredientRow extends StatelessWidget {
  const _AddIngredientRow({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) => onSubmit(),
            decoration: const InputDecoration(
              labelText: 'Zutat hinzufügen',
              hintText: 'z. B. Reis',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.add),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: onSubmit,
          icon: const Icon(Icons.check),
          tooltip: 'Hinzufügen',
        ),
      ],
    );
  }
}
