import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/plant.dart';
import '../../widgets/section_header.dart';
import 'cubit/plants_cubit.dart';
import 'cubit/plants_state.dart';
import 'plant_detail_page.dart';
import 'widgets/plant_card.dart';
import 'widgets/plant_form_sheet.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(BuildContext context, Plant plant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlantDetailPage(
          plantId: plant.id,
          heroTag: 'plant-${plant.id}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showPlantFormSheet(context),
        backgroundColor: AppColors.leaf,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add plant'),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PlantsCubit, PlantsState>(
          builder: (context, state) {
            final visible = state.filtered();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My plants',
                            style:
                                Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 6),
                        Text(
                          state.plants.isEmpty
                              ? 'Your collection is waiting'
                              : '${state.plants.length} plants under your care',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _search,
                          onChanged: context.read<PlantsCubit>().setQuery,
                          decoration: InputDecoration(
                            hintText: 'Search your plants',
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.inkSoft),
                            suffixIcon: state.query.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.close,
                                        color: AppColors.inkSoft),
                                    onPressed: () {
                                      _search.clear();
                                      context
                                          .read<PlantsCubit>()
                                          .setQuery('');
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _roomFilter(context, state)),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                if (visible.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: SproutEmpty(
                      icon: state.plants.isEmpty
                          ? Icons.local_florist_outlined
                          : Icons.search_off_rounded,
                      title: state.plants.isEmpty
                          ? 'No plants yet'
                          : 'No matches',
                      message: state.plants.isEmpty
                          ? 'Add your first plant and Sprout will remind you '
                              'when it needs water.'
                          : 'Try another search or room filter.',
                      action: state.plants.isEmpty
                          ? FilledButton.icon(
                              onPressed: () => showPlantFormSheet(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Add plant'),
                            )
                          : null,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.76,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final plant = visible[i];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration:
                                Duration(milliseconds: 380 + i * 60),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 22),
                                child: child,
                              ),
                            ),
                            child: PlantCard(
                              plant: plant,
                              now: now,
                              heroTag: 'plant-${plant.id}',
                              onTap: () => _open(context, plant),
                              onWater: () =>
                                  context.read<PlantsCubit>().waterPlant(plant.id),
                            ),
                          );
                        },
                        childCount: visible.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _roomFilter(BuildContext context, PlantsState state) {
    final rooms = state.rooms;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: rooms.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final room = rooms[i];
          final active = room == state.room;
          return GestureDetector(
            onTap: () => context.read<PlantsCubit>().setRoom(room),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.leaf : AppColors.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: active ? AppColors.leaf : AppColors.line,
                ),
              ),
              child: Text(
                room,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: active ? Colors.white : AppColors.ink,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
