import '../data/suggestions_data.dart';
import '../models/activity_model.dart';
import '../models/suggestion_model.dart';

/// Service for generating personalized eco-friendly suggestions.
class SuggestionService {
  /// Get suggestions based on recent activities.
  List<SuggestionModel> getSuggestionsForActivities(
    List<ActivityModel> activities,
  ) {
    if (activities.isEmpty) {
      return SuggestionsData.topSuggestions(limit: 3);
    }

    final suggestions = <SuggestionModel>{};

    // Get suggestions for each activity type
    for (final activity in activities) {
      final matched = SuggestionsData.forActivity(activity.name);
      suggestions.addAll(matched);
    }

    // If not enough, add top suggestions
    if (suggestions.length < 3) {
      final top = SuggestionsData.topSuggestions(limit: 5);
      for (final s in top) {
        if (suggestions.length >= 5) break;
        suggestions.add(s);
      }
    }

    return suggestions.toList();
  }

  /// Get the most impactful suggestion based on user's highest emission category.
  SuggestionModel? getTopSuggestion(List<ActivityModel> activities) {
    if (activities.isEmpty) return null;

    // Find the highest emission activity
    final sorted = List<ActivityModel>.from(activities)
      ..sort((a, b) => b.co2Emission.compareTo(a.co2Emission));

    final topActivity = sorted.first;
    final suggestions = SuggestionsData.forActivity(topActivity.name);

    if (suggestions.isEmpty) {
      return SuggestionsData.forCategory(topActivity.category).firstOrNull;
    }

    // Return the suggestion with highest potential saving
    suggestions.sort((a, b) => b.potentialSaving.compareTo(a.potentialSaving));
    return suggestions.first;
  }

  /// Get category-specific suggestions.
  List<SuggestionModel> getSuggestionsForCategory(String category) {
    return SuggestionsData.forCategory(category);
  }
}
