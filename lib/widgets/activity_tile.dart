import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/activity_model.dart';

/// Activity list tile with category icon and CO2 display.
class ActivityTile extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onDelete;

  const ActivityTile({
    super.key,
    required this.activity,
    this.onDelete,
  });

  Color get _categoryColor {
    switch (activity.category) {
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

  IconData get _categoryIcon {
    switch (activity.category) {
      case 'Transport':
        return Icons.directions_car_rounded;
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Energy':
        return Icons.bolt_rounded;
      default:
        return Icons.eco_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(activity.id),
      direction: onDelete != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: EcoTheme.error.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: EcoTheme.error),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: EcoTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _categoryColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _categoryIcon,
                color: _categoryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Activity info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(
                      color: EcoTheme.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${activity.value.toStringAsFixed(1)} ${activity.unit} • ${DateFormat('MMM d, h:mm a').format(activity.timestamp)}',
                    style: const TextStyle(
                      color: EcoTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // CO2 value
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  activity.co2Emission < 1
                      ? '${(activity.co2Emission * 1000).toStringAsFixed(0)} g'
                      : '${activity.co2Emission.toStringAsFixed(2)} kg',
                  style: TextStyle(
                    color: _categoryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const Text(
                  'CO₂',
                  style: TextStyle(
                    color: EcoTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
