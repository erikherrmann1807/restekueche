import 'dart:convert';

import 'package:restekueche/data/model/detected_ingredient_model.dart';
import 'package:restekueche/utils/gemini_json.dart';

/// Reads the `ingredients` array out of a vision answer.
///
/// An answer without a single recognisable ingredient is a legitimate
/// result — a photo of a bare wall — so an empty list is returned rather
/// than thrown. Only a structurally broken answer raises.
List<DetectedIngredientModel> parseDetectedIngredients(
  Map<String, dynamic> response,
) {
  final String rawJson = extractJsonPayload(response);

  final Object? decoded;
  try {
    decoded = jsonDecode(rawJson);
  } on FormatException catch (error) {
    throw GeminiParseException('Ingredient JSON is malformed: '
        '${error.message}');
  }

  if (decoded is! Map<String, dynamic>) {
    throw GeminiParseException('Ingredient JSON is not an object.');
  }

  final Object? ingredients = decoded['ingredients'];
  if (ingredients is! List) {
    throw GeminiParseException('Ingredient JSON carries no list.');
  }

  return ingredients
      .whereType<Map<String, dynamic>>()
      .map(DetectedIngredientModel.fromJson)
      .where((DetectedIngredientModel entry) => entry.name.isNotEmpty)
      .toList();
}
