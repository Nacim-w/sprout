import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/sample_plants.dart';
import '../../../data/models/plant.dart';
import '../../../data/repositories/sprout_repository.dart';
import 'plants_state.dart';

class PlantsCubit extends Cubit<PlantsState> {
  PlantsCubit(this._repository)
      : super(PlantsState(
          plants: _repository.loadPlants() ?? buildSamplePlants(),
        ));

  final SproutRepository _repository;

  void _commit(List<Plant> plants) {
    emit(state.copyWith(plants: plants));
    _repository.savePlants(plants);
  }

  void setRoom(String room) => emit(state.copyWith(room: room));

  void setQuery(String query) => emit(state.copyWith(query: query));

  void addPlant({
    required String name,
    required String species,
    required String room,
    required String image,
    required String light,
    required int waterEveryDays,
    String notes = '',
  }) {
    final now = DateTime.now();
    final plant = Plant(
      id: _repository.newId(),
      name: name,
      species: species,
      room: room,
      image: image,
      light: light,
      waterEveryDays: waterEveryDays,
      lastWatered: now,
      notes: notes,
      history: [now],
    );
    _commit([plant, ...state.plants]);
  }

  void updatePlant(
    Plant plant, {
    required String name,
    required String species,
    required String room,
    required String image,
    required String light,
    required int waterEveryDays,
    required String notes,
  }) {
    _commit([
      for (final p in state.plants)
        if (p.id == plant.id)
          plant.copyWith(
            name: name,
            species: species,
            room: room,
            image: image,
            light: light,
            waterEveryDays: waterEveryDays,
            notes: notes,
          )
        else
          p,
    ]);
  }

  void deletePlant(String id) {
    _commit(state.plants.where((p) => p.id != id).toList());
  }

  /// Records a watering: resets the timer and logs the moment.
  void waterPlant(String id) {
    final now = DateTime.now();
    _commit([
      for (final p in state.plants)
        if (p.id == id)
          p.copyWith(
            lastWatered: now,
            history: [now, ...p.history].take(20).toList(),
          )
        else
          p,
    ]);
  }

  void waterAllDue() {
    final now = DateTime.now();
    _commit([
      for (final p in state.plants)
        if (p.needsWater(now))
          p.copyWith(
            lastWatered: now,
            history: [now, ...p.history].take(20).toList(),
          )
        else
          p,
    ]);
  }
}
