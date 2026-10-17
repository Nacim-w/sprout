import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/plant.dart';
import '../../../widgets/plant_photo.dart';
import 'water_button.dart';

class CareTaskTile extends StatelessWidget {
  const CareTaskTile({
    super.key,
    required this.plant,
    required this.now,
    required this.onTap,
    required this.onWater,
  });

  final Plant plant;
  final DateTime now;
  final VoidCallback onTap;
  final VoidCallback onWater;

  @override
  Widget build(BuildContext context) {
    final overdue = plant.isOverdue(now);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 56,
                height: 56,
                child: PlantPhoto(asset: plant.image),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        overdue
                            ? Icons.error_outline
                            : Icons.schedule,
                        size: 13,
                        color: overdue
                            ? AppColors.terracotta
                            : AppColors.inkSoft,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        dueLabel(plant.daysUntilDue(now)),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: overdue
                              ? AppColors.terracotta
                              : AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            WaterButton(
              compact: true,
              onWater: onWater,
            ),
          ],
        ),
      ),
    );
  }
}
