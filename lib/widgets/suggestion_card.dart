import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/suggestion_model.dart';

/// Card displaying an eco-friendly suggestion.
class SuggestionCard extends StatelessWidget {
  final SuggestionModel suggestion;

  const SuggestionCard({super.key, required this.suggestion});

  Color get _categoryColor {
    switch (suggestion.category) {
      case 'Transport':
        return EcoTheme.transportColor;
      case 'Food':
        return EcoTheme.foodColor;
      case 'Energy':
        return EcoTheme.energyColor;
      default:
        return EcoTheme.greenPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: EcoTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _categoryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                suggestion.icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  suggestion.title,
                  style: const TextStyle(
                    color: EcoTheme.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            suggestion.description,
            style: const TextStyle(
              color: EcoTheme.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _categoryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Save ~${suggestion.potentialSaving.toStringAsFixed(1)} kg CO₂',
              style: TextStyle(
                color: _categoryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
