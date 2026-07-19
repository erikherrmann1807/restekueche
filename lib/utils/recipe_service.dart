import 'dart:convert';

import 'package:restekueche/data/model/gemini_recipe_model.dart';

GeminiRecipeModel restructureJson(Map<String, dynamic> response) {
  final text = response['candidates'][0]['content']['parts'][0]['text'] as String;

  final start = text.indexOf('{');
  final end = text.lastIndexOf('}');
  final cleanJson = text.substring(start, end + 1);

  final inner = jsonDecode(cleanJson) as Map<String, dynamic>;
  print(inner);
  return GeminiRecipeModel.fromJson(inner);
}
