class GeminiRecipeModel {
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String duration;

  GeminiRecipeModel({
   required this.title,
   required this.ingredients,
   required this.steps,
   required this.duration
});

  factory GeminiRecipeModel.fromJson(Map<String, dynamic> json) {
    return GeminiRecipeModel(
        title: json['title'] as String? ?? '',
        ingredients: (json['ingredients'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        steps: (json['steps'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        duration: json['duration'] as String? ?? ''
    );
  }
}
