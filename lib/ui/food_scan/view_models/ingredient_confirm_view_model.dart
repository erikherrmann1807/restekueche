import 'package:flutter/material.dart';
import 'package:restekueche/domain/models/detected_ingredient.dart';

/// One row on the confirmation screen: what the model proposed plus what
/// the user made of it.
class EditableIngredient {
  EditableIngredient({
    required this.name,
    required this.confidence,
    required this.selected,
  });

  String name;
  final double confidence;
  bool selected;

  /// Manually typed entries carry no model guess, so they are never shown
  /// as uncertain.
  bool get isUncertain => confidence < 0.6;
}

class IngredientConfirmViewModel extends ChangeNotifier {
  IngredientConfirmViewModel({
    required List<DetectedIngredient> detected,
  }) : _ingredients = detected
           .map(
             (DetectedIngredient ingredient) => EditableIngredient(
               name: ingredient.name,
               confidence: ingredient.confidence,
               // Uncertain guesses start unchecked: the user opts into a
               // shaky suggestion instead of having to spot and remove it.
               selected: !ingredient.isUncertain,
             ),
           )
           .toList(),
       hasDetections = detected.isNotEmpty;

  final List<EditableIngredient> _ingredients;

  /// Whether the model actually proposed something. Without a detection
  /// there is no AI guess to warn about, so the screen stays quiet.
  final bool hasDetections;

  List<EditableIngredient> get ingredients =>
      List<EditableIngredient>.unmodifiable(_ingredients);

  List<String> get confirmedIngredients => _ingredients
      .where((EditableIngredient entry) => entry.selected)
      .map((EditableIngredient entry) => entry.name)
      .toList();

  int get selectedCount => confirmedIngredients.length;

  void toggle(int index) {
    final EditableIngredient entry = _ingredients[index];
    entry.selected = !entry.selected;
    notifyListeners();
  }

  void rename(int index, String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _ingredients[index].name = trimmed;
    notifyListeners();
  }

  void remove(int index) {
    _ingredients.removeAt(index);
    notifyListeners();
  }

  /// Adds an ingredient the user typed. Duplicates are folded into the
  /// existing row rather than added twice.
  void add(String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final int existing = _ingredients.indexWhere(
      (EditableIngredient entry) =>
          entry.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (existing != -1) {
      _ingredients[existing].selected = true;
    } else {
      _ingredients.add(
        EditableIngredient(name: trimmed, confidence: 1, selected: true),
      );
    }
    notifyListeners();
  }
}
