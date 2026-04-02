import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Animated progress bar for gamification levels.
class EcoProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String label;
  final String? trailingText;
  final Color? color;
  final double height;

  const EcoProgressBar({
    super.key,
    required this.progress,
    required this.label,
    this.trailingText,
    this.color,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = color ?? EcoTheme.greenLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: EcoTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(
                  color: barColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: barColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(height),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          barColor,
                          barColor.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(height),
                      boxShadow: [
                        BoxShadow(
                          color: barColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
