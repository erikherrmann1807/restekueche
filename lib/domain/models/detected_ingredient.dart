class DetectedIngredient {
  const DetectedIngredient({required this.name, required this.confidence});

  final String name;

  /// How sure the model is, between 0 and 1.
  final double confidence;

  /// Below this the suggestion is shown but not pre-selected — the user
  /// has to opt in rather than opt out of a likely wrong guess.
  bool get isUncertain => confidence < 0.6;
}
