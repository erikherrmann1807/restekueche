import 'dart:convert';

import 'package:restekueche/data/model/gemini_recipe_model.dart';
import 'package:restekueche/utils/gemini_json.dart';

GeminiRecipeModel restructureJson(Map<String, dynamic> response) {
  final String rawJson = extractJsonPayload(response);

  final Object? decoded;
  try {
    decoded = jsonDecode(rawJson);
  } on FormatException catch (error) {
    // A truncated answer (finishReason MAX_TOKENS) leaves invalid JSON.
    throw GeminiParseException('Recipe JSON is malformed: ${error.message}');
  }

  if (decoded is! Map<String, dynamic>) {
    throw GeminiParseException('Recipe JSON is not an object.');
  }

  return GeminiRecipeModel.fromJson(decoded);
}
