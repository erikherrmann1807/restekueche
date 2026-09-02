class GeminiRecipeModel {
  GeminiRecipeModel({
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.duration,
  });

  factory GeminiRecipeModel.fromJson(Map<String, dynamic> json) {
    return GeminiRecipeModel(
      title: _asText(json['title']),
      ingredients: _asTextList(json['ingredients']),
      steps: _asTextList(json['steps']),
      duration: _asText(json['duration']),
    );
  }

  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String duration;

  /// The model does not always honour the requested types — `duration` in
  /// particular comes back as a bare number often enough that casting to
  /// String throws. Coerce instead of crashing on an otherwise fine recipe.
  static String _asText(Object? value) => value?.toString().trim() ?? '';

  static List<String> _asTextList(Object? value) {
    if (value is! List) {
      return const <String>[];
    }
    return value
        .map(_asText)
        .where((String entry) => entry.isNotEmpty)
        .toList();
  }
}
