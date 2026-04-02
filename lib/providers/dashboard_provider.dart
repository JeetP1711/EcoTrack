import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../models/suggestion_model.dart';
import '../services/suggestion_service.dart';

/// Provider for dashboard data computed from activities.
class DashboardProvider with ChangeNotifier {
  final SuggestionService _suggestionService = SuggestionService();

  String _selectedPeriod = 'Daily';
  List<SuggestionModel> _suggestions = [];

  String get selectedPeriod => _selectedPeriod;
  List<SuggestionModel> get suggestions => _suggestions;

  /// Update the selected period (Daily / Weekly / Monthly).
  void setPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  /// Refresh suggestions based on recent activities.
  void refreshSuggestions(List<ActivityModel> activities) {
    _suggestions = _suggestionService.getSuggestionsForActivities(activities);
    notifyListeners();
  }

  /// Get the top suggestion.
  SuggestionModel? getTopSuggestion(List<ActivityModel> activities) {
    return _suggestionService.getTopSuggestion(activities);
  }
}
