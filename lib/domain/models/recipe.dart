
class Recipe {

  Recipe({
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.duration
});
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String duration;
}


