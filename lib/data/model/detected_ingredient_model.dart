class DetectedIngredientModel {
  DetectedIngredientModel({required this.name, required this.confidence});

  factory DetectedIngredientModel.fromJson(Map<String, dynamic> json) {
    return DetectedIngredientModel(
      name: _asText(json['name']),
      confidence: _asConfidence(json['confidence']),
    );
  }

  final String name;
  final double confidence;

  static String _asText(Object? value) => value?.toString().trim() ?? '';

  /// The model returns confidence as a number most of the time, but a
  /// bare string ('0.8', or even '80%') shows up often enough that
  /// casting to double throws on an otherwise fine detection.
  static double _asConfidence(Object? value) {
    final double? parsed = switch (value) {
      final num number => number.toDouble(),
      final String text => double.tryParse(text.replaceAll('%', '').trim()),
      _ => null,
    };

    if (parsed == null) {
      // Neither confident nor dismissible — let the user decide.
      return 0.5;
    }
    // A percentage slipped through as 80 instead of 0.8.
    final double normalised = parsed > 1 ? parsed / 100 : parsed;
    return normalised.clamp(0.0, 1.0);
  }
}
