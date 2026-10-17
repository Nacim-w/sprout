import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// A soft rounded bar that fills as a plant becomes thirsty.
class HydrationBar extends StatelessWidget {
  const HydrationBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color = AppColors.leaf,
    this.backgroundColor = AppColors.surfaceAlt,
  });

  final double value;
  final double height;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: Stack(
            children: [
              Container(height: height, color: backgroundColor),
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    height: height,
                    width: constraints.maxWidth * v,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.7), color],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
