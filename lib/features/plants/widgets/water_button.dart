import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A watering button that erupts in droplets when pressed — a small,
/// satisfying bit of feedback before the care state updates.
class WaterButton extends StatefulWidget {
  const WaterButton({
    super.key,
    required this.onWater,
    this.label = 'Water now',
    this.compact = false,
  });

  final VoidCallback onWater;
  final String label;
  final bool compact;

  @override
  State<WaterButton> createState() => _WaterButtonState();
}

class _WaterButtonState extends State<WaterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onWater();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            height: widget.compact ? 44 : 58,
            padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? 16 : 34),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.leaf, AppColors.leafDeep],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.leaf.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop, color: Colors.white, size: 20),
                if (!widget.compact) ...[
                  const SizedBox(width: 10),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _DropletPainter(progress: _controller.value),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropletPainter extends CustomPainter {
  _DropletPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress >= 1) return;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = AppColors.sprout.withValues(
      alpha: (1 - progress) * 0.9,
    );
    const count = 7;
    for (var i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final distance = 24 + progress * 46;
      final offset = center +
          Offset(math.cos(angle) * distance, math.sin(angle) * distance);
      final radius = (1 - progress) * 5;
      if (radius > 0.2) canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DropletPainter old) =>
      old.progress != progress;
}
