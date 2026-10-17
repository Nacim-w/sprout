import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/plant.dart';
import '../../widgets/plant_photo.dart';
import '../../widgets/progress_ring.dart';
import 'cubit/plants_cubit.dart';
import 'cubit/plants_state.dart';
import 'widgets/plant_form_sheet.dart';
import 'widgets/water_button.dart';

class PlantDetailPage extends StatelessWidget {
  const PlantDetailPage({
    super.key,
    required this.plantId,
    required this.heroTag,
  });

  final String plantId;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BlocBuilder<PlantsCubit, PlantsState>(
      builder: (context, state) {
        final plant = state.byId(plantId);
        if (plant == null) {
          return const Scaffold(
            body: Center(child: Text('This plant is no longer here.')),
          );
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _header(context, plant),
              SliverToBoxAdapter(child: _metaRow(context, plant)),
              SliverToBoxAdapter(child: _waterCard(context, plant, now)),
              if (plant.notes.isNotEmpty)
                SliverToBoxAdapter(child: _notesCard(context, plant)),
              SliverToBoxAdapter(child: _history(context, plant)),
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, Plant plant) {
    return SliverAppBar(
      expandedHeight: 360,
      pinned: true,
      backgroundColor: AppColors.canvas,
      leading: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: _glass(Icons.arrow_back),
        ),
      ),
      actions: [
        Center(
          child: GestureDetector(
            onTap: () => showPlantFormSheet(context, existing: plant),
            child: _glass(Icons.edit_outlined),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () => _confirmDelete(context, plant),
            child: _glass(Icons.delete_outline),
          ),
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            PlantPhoto(
              asset: plant.image,
              heroTag: heroTag,
              gradient: plantScrim,
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    plant.species.isEmpty
                        ? plant.room.toUpperCase()
                        : plant.species.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(BuildContext context, Plant plant) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          _MetaChip(icon: Icons.meeting_room_outlined, label: plant.room),
          const SizedBox(width: 10),
          _MetaChip(icon: Icons.wb_sunny_outlined, label: '${plant.light} light'),
          const SizedBox(width: 10),
          _MetaChip(
            icon: Icons.water_drop_outlined,
            label: 'Every ${plant.waterEveryDays}d',
          ),
        ],
      ),
    );
  }

  Widget _waterCard(BuildContext context, Plant plant, DateTime now) {
    final due = plant.daysUntilDue(now);
    final hydration = plant.hydrationLeft(now);
    final thirsty = plant.needsWater(now);
    final accent = thirsty ? AppColors.terracotta : AppColors.leaf;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.line),
          boxShadow: AppTheme.softShadow(strength: 0.6),
        ),
        child: Column(
          children: [
            ProgressRing(
              value: hydration,
              size: 150,
              stroke: 14,
              color: accent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(hydration * 100).round()}%',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const Text(
                    'hydrated',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dueLabel(due),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Last watered ${monthDay(plant.lastWatered)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            WaterButton(
              label: thirsty ? 'Water now' : 'Give a drink anyway',
              onWater: () {
                context.read<PlantsCubit>().waterPlant(plant.id);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('${plant.name} has been watered.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _notesCard(BuildContext context, Plant plant) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline, color: AppColors.leaf),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                plant.notes,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _history(BuildContext context, Plant plant) {
    final history = plant.history.take(6).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CARE HISTORY',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.leaf)),
          const SizedBox(height: 14),
          if (history.isEmpty)
            Text('No watering recorded yet.',
                style: Theme.of(context).textTheme.bodyMedium)
          else
            ...history.map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceAlt,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.water_drop,
                          size: 16, color: AppColors.leaf),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Watered · ${longDate(d)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _glass(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.26),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Icon(icon, size: 19, color: Colors.white),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Plant plant) async {
    final cubit = context.read<PlantsCubit>();
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Remove plant?'),
        content: Text('${plant.name} will be removed from your collection.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok == true) {
      cubit.deletePlant(plant.id);
      navigator.maybePop();
    }
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.leaf),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
