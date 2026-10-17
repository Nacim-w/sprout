import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/plant.dart';
import '../../../widgets/hydration_bar.dart';
import '../../../widgets/plant_photo.dart';

class PlantCard extends StatefulWidget {
  const PlantCard({
    super.key,
    required this.plant,
    required this.now,
    required this.heroTag,
    required this.onTap,
    required this.onWater,
  });

  final Plant plant;
  final DateTime now;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onWater;

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.plant;
    final thirsty = p.needsWater(widget.now);
    final hydration = p.hydration(widget.now);
    final due = p.daysUntilDue(widget.now);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 160),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: AppTheme.softShadow(strength: _pressed ? 0.5 : 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              fit: StackFit.expand,
              children: [
                PlantPhoto(
                  asset: p.image,
                  heroTag: widget.heroTag,
                  gradient: plantScrim,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _StatusBadge(
                    thirsty: thirsty,
                    label: due < 0 ? 'Thirsty' : 'Happy',
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p.room.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      HydrationBar(
                        value: hydration,
                        height: 6,
                        color: thirsty
                            ? AppColors.terracotta
                            : AppColors.sprout,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.25),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dueLabel(due),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (thirsty)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: widget.onWater,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.leaf,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.leaf.withValues(alpha: 0.5),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.water_drop,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.thirsty, required this.label});

  final bool thirsty;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = thirsty ? AppColors.terracotta : AppColors.leaf;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            thirsty ? Icons.water_drop : Icons.eco,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
