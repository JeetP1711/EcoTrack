import '../models/suggestion_model.dart';

/// Context-aware suggestions dataset.
class SuggestionsData {
  static const List<SuggestionModel> allSuggestions = [
    // ─── Transport Suggestions ──────────────────────────────────────
    SuggestionModel(
      id: 's1',
      category: 'Transport',
      triggerActivity: 'Petrol Car',
      title: 'Switch to Electric Vehicle',
      description:
          'EVs produce 75% less CO₂ per km. Consider switching to an EV for daily commutes and save up to 3 tons of CO₂ per year.',
      icon: '⚡',
      potentialSaving: 3.2,
    ),
    SuggestionModel(
      id: 's2',
      category: 'Transport',
      triggerActivity: 'Petrol Car',
      title: 'Try Public Transport',
      description:
          'Using a bus or train instead of driving alone can reduce your transport emissions by 60-80%.',
      icon: '🚌',
      potentialSaving: 2.5,
    ),
    SuggestionModel(
      id: 's3',
      category: 'Transport',
      triggerActivity: 'Diesel Car',
      title: 'Carpool with Colleagues',
      description:
          'Sharing rides can cut your per-person emissions in half while saving on fuel costs.',
      icon: '🤝',
      potentialSaving: 1.8,
    ),
    SuggestionModel(
      id: 's4',
      category: 'Transport',
      triggerActivity: 'Flight (Domestic)',
      title: 'Consider Train Travel',
      description:
          'Trains emit 6x less CO₂ than domestic flights. For trips under 500km, trains are often faster too.',
      icon: '🚆',
      potentialSaving: 5.0,
    ),
    SuggestionModel(
      id: 's5',
      category: 'Transport',
      triggerActivity: 'Motorcycle',
      title: 'Cycle for Short Trips',
      description:
          'For trips under 5km, cycling is faster than driving in cities and produces zero emissions.',
      icon: '🚲',
      potentialSaving: 0.5,
    ),

    // ─── Food Suggestions ───────────────────────────────────────────
    SuggestionModel(
      id: 's6',
      category: 'Food',
      triggerActivity: 'Beef',
      title: 'Try Plant-Based Alternatives',
      description:
          'Replacing beef with lentils saves 26 kg CO₂ per kg. Try Meatless Mondays to start!',
      icon: '🌱',
      potentialSaving: 26.0,
    ),
    SuggestionModel(
      id: 's7',
      category: 'Food',
      triggerActivity: 'Lamb',
      title: 'Switch to Chicken or Fish',
      description:
          'Chicken and fish have 3-4x lower emissions than lamb. A small swap makes a big impact.',
      icon: '🍗',
      potentialSaving: 18.0,
    ),
    SuggestionModel(
      id: 's8',
      category: 'Food',
      triggerActivity: 'Dairy (Milk/Cheese)',
      title: 'Try Oat or Soy Milk',
      description:
          'Plant-based milks produce 60% less CO₂ than dairy milk and use 80% less land.',
      icon: '🥛',
      potentialSaving: 1.9,
    ),
    SuggestionModel(
      id: 's9',
      category: 'Food',
      triggerActivity: 'Rice',
      title: 'Mix in Quinoa or Millet',
      description:
          'Replacing some rice with millets reduces methane emissions from paddy farming.',
      icon: '🌾',
      potentialSaving: 1.5,
    ),

    // ─── Energy Suggestions ─────────────────────────────────────────
    SuggestionModel(
      id: 's10',
      category: 'Energy',
      triggerActivity: 'Electricity',
      title: 'Switch to LED Lighting',
      description:
          'LED bulbs use 75% less electricity than incandescent. Replace all bulbs to save ~100 kWh/year.',
      icon: '💡',
      potentialSaving: 1.5,
    ),
    SuggestionModel(
      id: 's11',
      category: 'Energy',
      triggerActivity: 'Electricity',
      title: 'Use a Smart Power Strip',
      description:
          'Smart strips eliminate phantom loads from idle electronics, saving 5-10% on electricity bills.',
      icon: '🔌',
      potentialSaving: 0.8,
    ),
    SuggestionModel(
      id: 's12',
      category: 'Energy',
      triggerActivity: 'Natural Gas',
      title: 'Improve Home Insulation',
      description:
          'Proper insulation can reduce heating gas consumption by 30-50%.',
      icon: '🏠',
      potentialSaving: 3.0,
    ),
    SuggestionModel(
      id: 's13',
      category: 'Energy',
      triggerActivity: 'LPG',
      title: 'Switch to Induction Cooking',
      description:
          'Induction cooktops are 90% efficient vs 40% for gas. They also reduce indoor air pollution.',
      icon: '🍳',
      potentialSaving: 1.2,
    ),
    SuggestionModel(
      id: 's14',
      category: 'Energy',
      triggerActivity: 'Electricity',
      title: 'Install Solar Panels',
      description:
          'Rooftop solar can offset 80-100% of your electricity emissions and pays for itself in 5-7 years.',
      icon: '☀️',
      potentialSaving: 5.0,
    ),
  ];

  /// Get suggestions matching a specific activity name.
  static List<SuggestionModel> forActivity(String activityName) {
    return allSuggestions
        .where((s) => s.triggerActivity == activityName)
        .toList();
  }

  /// Get suggestions for a category.
  static List<SuggestionModel> forCategory(String category) {
    return allSuggestions.where((s) => s.category == category).toList();
  }

  /// Get top suggestions based on potential saving.
  static List<SuggestionModel> topSuggestions({int limit = 5}) {
    final sorted = List<SuggestionModel>.from(allSuggestions)
      ..sort((a, b) => b.potentialSaving.compareTo(a.potentialSaving));
    return sorted.take(limit).toList();
  }
}
