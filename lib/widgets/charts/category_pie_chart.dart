import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// Pie chart showing emission breakdown by category.
class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data; // category → total CO2

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0.0, (sum, v) => sum + v);
    final hasData = total > 0;

    final categories = [
      _CategoryInfo('Transport', EcoTheme.transportColor, Icons.directions_car_rounded),
      _CategoryInfo('Food', EcoTheme.foodColor, Icons.restaurant_rounded),
      _CategoryInfo('Energy', EcoTheme.energyColor, Icons.bolt_rounded),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: EcoTheme.glassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Breakdown',
            style: TextStyle(
              color: EcoTheme.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'CO₂ emissions by category',
            style: TextStyle(
              color: EcoTheme.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                // Pie chart
                Expanded(
                  flex: 3,
                  child: hasData
                      ? PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 35,
                            sections: categories.map((cat) {
                              final value = data[cat.name] ?? 0;
                              final percentage =
                                  total > 0 ? (value / total * 100) : 0;
                              return PieChartSectionData(
                                color: cat.color,
                                value: value == 0 ? 0.01 : value,
                                title: percentage > 5
                                    ? '${percentage.toStringAsFixed(0)}%'
                                    : '',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                radius: 45,
                              );
                            }).toList(),
                          ),
                          duration: const Duration(milliseconds: 800),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pie_chart_outline_rounded,
                                color: EcoTheme.textMuted.withValues(alpha: 0.5),
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'No data yet',
                                style: TextStyle(
                                  color: EcoTheme.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                // Legend
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: categories.map((cat) {
                      final value = data[cat.name] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: cat.color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat.name,
                                    style: const TextStyle(
                                      color: EcoTheme.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${value.toStringAsFixed(1)} kg',
                                    style: TextStyle(
                                      color: cat.color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryInfo {
  final String name;
  final Color color;
  final IconData icon;
  const _CategoryInfo(this.name, this.color, this.icon);
}
