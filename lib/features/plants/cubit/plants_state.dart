import 'package:equatable/equatable.dart';

import '../../../core/sample_plants.dart';
import '../../../data/models/plant.dart';

class PlantsState extends Equatable {
  const PlantsState({
    required this.plants,
    this.room = 'All',
    this.query = '',
  });

  final List<Plant> plants;
  final String room;
  final String query;

  List<String> get rooms {
    final set = <String>{'All', ...plants.map((p) => p.room)};
    return set.toList();
  }

  List<Plant> filtered() {
    final q = query.trim().toLowerCase();
    return plants.where((p) {
      final matchesRoom = room == 'All' || p.room == room;
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.species.toLowerCase().contains(q) ||
          p.room.toLowerCase().contains(q);
      return matchesRoom && matchesQuery;
    }).toList();
  }

  List<Plant> needsWater(DateTime now) {
    final list =
        plants.where((p) => p.needsWater(now)).toList()
          ..sort((a, b) =>
              a.daysUntilDue(now).compareTo(b.daysUntilDue(now)));
    return list;
  }

  List<Plant> upcoming(DateTime now) {
    final list = plants
        .where((p) => p.daysUntilDue(now) > 0 && p.daysUntilDue(now) <= 7)
        .toList()
      ..sort((a, b) => a.daysUntilDue(now).compareTo(b.daysUntilDue(now)));
    return list;
  }

  List<Plant> wateredToday(DateTime now) {
    return plants.where((p) {
      return p.lastWatered.year == now.year &&
          p.lastWatered.month == now.month &&
          p.lastWatered.day == now.day;
    }).toList();
  }

  double get careProgress {
    if (plants.isEmpty) return 0;
    final now = DateTime.now();
    final happy = plants.where((p) => !p.needsWater(now)).length;
    return happy / plants.length;
  }

  Plant? byId(String id) {
    for (final p in plants) {
      if (p.id == id) return p;
    }
    return null;
  }

  PlantsState copyWith({List<Plant>? plants, String? room, String? query}) {
    return PlantsState(
      plants: plants ?? this.plants,
      room: room ?? this.room,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [plants, room, query];
}

/// Rooms shown even before any plant is added.
List<String> get defaultRooms => plantRooms;
