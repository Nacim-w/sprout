import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/plant.dart';
import '../../widgets/section_header.dart';
import '../plants/cubit/plants_cubit.dart';
import '../plants/cubit/plants_state.dart';
import '../plants/plant_detail_page.dart';
import '../plants/widgets/care_task_tile.dart';

class CarePage extends StatelessWidget {
  const CarePage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PlantsCubit, PlantsState>(
          builder: (context, state) {
            final overdue = <Plant>[];
            final today = <Plant>[];
            final week = <Plant>[];
            final later = <Plant>[];
            for (final p in state.plants) {
              final d = p.daysUntilDue(now);
              if (d < 0) {
                overdue.add(p);
              } else if (d == 0) {
                today.add(p);
              } else if (d <= 7) {
                week.add(p);
              } else {
                later.add(p);
              }
            }
            for (final list in [overdue, today, week, later]) {
              list.sort((a, b) =>
                  a.daysUntilDue(now).compareTo(b.daysUntilDue(now)));
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Care',
                            style:
                                Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 6),
                        Text(
                          'A gentle schedule for your collection',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.plants.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: SproutEmpty(
                      icon: Icons.spa_outlined,
                      title: 'Nothing to care for',
                      message:
                          'Add a plant and it will appear here with a '
                          'watering schedule.',
                    ),
                  )
                else ...[
                  ..._group(context, 'Overdue', 'Needs attention now', overdue, now),
                  ..._group(context, 'Today', 'Water these today', today, now),
                  ..._group(context, 'This week', 'Coming up soon', week, now),
                  ..._group(context, 'Later', 'On the horizon', later, now),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _group(
    BuildContext context,
    String title,
    String eyebrow,
    List<Plant> plants,
    DateTime now,
  ) {
    if (plants.isEmpty) return const [];
    return [
      SliverToBoxAdapter(
        child: SectionHeader(eyebrow: eyebrow, title: title),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList.builder(
          itemCount: plants.length,
          itemBuilder: (context, i) {
            final p = plants[i];
            return CareTaskTile(
              plant: p,
              now: now,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      PlantDetailPage(plantId: p.id, heroTag: 'care-${p.id}'),
                ),
              ),
              onWater: () => context.read<PlantsCubit>().waterPlant(p.id),
            );
          },
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
    ];
  }
}
