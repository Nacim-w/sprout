import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/plant.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/plant_photo.dart';
import '../../widgets/section_header.dart';
import '../plants/plant_detail_page.dart';
import '../plants/cubit/plants_cubit.dart';
import '../plants/cubit/plants_state.dart';
import '../plants/widgets/care_task_tile.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key, required this.onOpenCare});

  final VoidCallback onOpenCare;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PlantsCubit, PlantsState>(
          builder: (context, state) {
            final due = state.needsWater(now);
            final upcoming = state.upcoming(now);
            final thriving = state.plants
                .where((p) => !p.needsWater(now))
                .toList();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _greeting(context, now)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _CareSummary(
                      total: state.plants.length,
                      due: due.length,
                      progress: state.careProgress,
                      onWaterAll: due.isEmpty
                          ? null
                          : () => context.read<PlantsCubit>().waterAllDue(),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    eyebrow: 'Care',
                    title: due.isEmpty ? 'Nothing needs water' : 'Needs water',
                    trailing: TextButton(
                      onPressed: onOpenCare,
                      child: const Text('See all'),
                    ),
                  ),
                ),
                if (due.isEmpty)
                  const SliverToBoxAdapter(child: _AllGood())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList.builder(
                      itemCount: due.length > 4 ? 4 : due.length,
                      itemBuilder: (context, i) {
                        final p = due[i];
                        return CareTaskTile(
                          plant: p,
                          now: now,
                          onTap: () => _open(context, p),
                          onWater: () =>
                              context.read<PlantsCubit>().waterPlant(p.id),
                        );
                      },
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    eyebrow: 'Doing well',
                    title: 'Thriving right now',
                  ),
                ),
                SliverToBoxAdapter(
                  child: _ThrivingRow(
                    plants: thriving,
                    now: now,
                    onOpen: (p) => _open(context, p),
                  ),
                ),
                if (upcoming.isNotEmpty) ...[
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  const SliverToBoxAdapter(
                    child: SectionHeader(
                      eyebrow: 'This week',
                      title: 'Coming up',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _UpcomingRow(plants: upcoming, now: now),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            );
          },
        ),
      ),
    );
  }

  void _open(BuildContext context, Plant plant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlantDetailPage(plantId: plant.id, heroTag: 'today-${plant.id}'),
      ),
    );
  }

  Widget _greeting(BuildContext context, DateTime now) {
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 18
            ? 'Good afternoon'
            : 'Good evening';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${weekdayName(now).toUpperCase()} · ${monthDay(now).toUpperCase()}',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
              color: AppColors.leaf,
            ),
          ),
          const SizedBox(height: 6),
          Text(greeting, style: Theme.of(context).textTheme.displayLarge),
        ],
      ),
    );
  }
}

class _CareSummary extends StatelessWidget {
  const _CareSummary({
    required this.total,
    required this.due,
    required this.progress,
    required this.onWaterAll,
  });

  final int total;
  final int due;
  final double progress;
  final VoidCallback? onWaterAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.leaf, AppColors.leafDeep],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppTheme.softShadow(strength: 1.2),
      ),
      child: Row(
        children: [
          ProgressRing(
            value: progress,
            size: 104,
            stroke: 11,
            color: Colors.white,
            trackColor: Colors.white.withValues(alpha: 0.25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'happy',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  due == 0
                      ? 'Everyone is happy'
                      : '$due of $total need water',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  due == 0
                      ? 'Nice work — check back tomorrow.'
                      : 'A quick drink keeps them thriving.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                if (onWaterAll != null) ...[
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: onWaterAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.water_drop,
                              size: 15, color: AppColors.leafDeep),
                          SizedBox(width: 6),
                          Text(
                            'Water all',
                            style: TextStyle(
                              color: AppColors.leafDeep,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllGood extends StatelessWidget {
  const _AllGood();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            const Icon(Icons.spa_outlined, color: AppColors.leaf, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'All your plants are watered. Enjoy the calm.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThrivingRow extends StatelessWidget {
  const _ThrivingRow({
    required this.plants,
    required this.now,
    required this.onOpen,
  });

  final List<Plant> plants;
  final DateTime now;
  final void Function(Plant) onOpen;

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Text('No plants yet — add one to get started.',
            style: TextStyle(color: AppColors.inkSoft)),
      );
    }
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: plants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final p = plants[i];
          return _ThrivingPill(plant: p, now: now, onTap: () => onOpen(p));
        },
      ),
    );
  }
}

class _ThrivingPill extends StatelessWidget {
  const _ThrivingPill({
    required this.plant,
    required this.now,
    required this.onTap,
  });

  final Plant plant;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 104,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 104,
                height: 96,
                child: PlantPhoto(
                  asset: plant.image,
                  heroTag: 'today-${plant.id}',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              plant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
                color: AppColors.ink,
              ),
            ),
            Text(
              dueLabel(plant.daysUntilDue(now)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({required this.plants, required this.now});

  final List<Plant> plants;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: plants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final p = plants[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: PlantPhoto(asset: p.image),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      dueLabel(p.daysUntilDue(now)),
                      style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
