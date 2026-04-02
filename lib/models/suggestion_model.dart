/// Smart suggestion model for eco-friendly alternatives.
class SuggestionModel {
  final String id;
  final String category;       // Transport, Food, Energy
  final String triggerActivity; // what activity triggers this suggestion
  final String title;
  final String description;
  final String icon;
  final double potentialSaving; // estimated CO2 saving in kg per use

  const SuggestionModel({
    required this.id,
    required this.category,
    required this.triggerActivity,
    required this.title,
    required this.description,
    required this.icon,
    required this.potentialSaving,
  });
}
