import 'package:equatable/equatable.dart';

class Plant extends Equatable {
  const Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.room,
    required this.image,
    required this.light,
    required this.waterEveryDays,
    required this.lastWatered,
    this.notes = '',
    this.history = const [],
  });

  final String id;
  final String name;
  final String species;
  final String room;
  final String image;
  final String light;
  final int waterEveryDays;
  final DateTime lastWatered;
  final String notes;
  final List<DateTime> history;

  DateTime get nextDue => lastWatered.add(Duration(days: waterEveryDays));

  /// Whole days until the next watering (negative when overdue).
  int daysUntilDue(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(nextDue.year, nextDue.month, nextDue.day);
    return due.difference(today).inDays;
  }

  bool isOverdue(DateTime now) => daysUntilDue(now) < 0;

  bool isDueToday(DateTime now) => daysUntilDue(now) == 0;

  bool needsWater(DateTime now) => daysUntilDue(now) <= 0;

  /// 0 = freshly watered, 1 = fully due. Clamped for safe UI use.
  double hydration(DateTime now) {
    if (waterEveryDays <= 0) return 0;
    final elapsed = now.difference(lastWatered).inHours;
    final span = waterEveryDays * 24;
    return (elapsed / span).clamp(0.0, 1.0);
  }

  double hydrationLeft(DateTime now) => 1 - hydration(now);

  Plant copyWith({
    String? name,
    String? species,
    String? room,
    String? image,
    String? light,
    int? waterEveryDays,
    DateTime? lastWatered,
    String? notes,
    List<DateTime>? history,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      room: room ?? this.room,
      image: image ?? this.image,
      light: light ?? this.light,
      waterEveryDays: waterEveryDays ?? this.waterEveryDays,
      lastWatered: lastWatered ?? this.lastWatered,
      notes: notes ?? this.notes,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'room': room,
        'image': image,
        'light': light,
        'waterEveryDays': waterEveryDays,
        'lastWatered': lastWatered.toIso8601String(),
        'notes': notes,
        'history': history.map((d) => d.toIso8601String()).toList(),
      };

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json['id'] as String,
        name: json['name'] as String,
        species: json['species'] as String? ?? '',
        room: json['room'] as String? ?? 'Home',
        image: json['image'] as String? ?? '',
        light: json['light'] as String? ?? 'Medium',
        waterEveryDays: json['waterEveryDays'] as int? ?? 7,
        lastWatered: DateTime.parse(json['lastWatered'] as String),
        notes: json['notes'] as String? ?? '',
        history: (json['history'] as List<dynamic>? ?? [])
            .map((e) => DateTime.parse(e as String))
            .toList(),
      );

  @override
  List<Object?> get props =>
      [id, name, species, room, image, light, waterEveryDays, lastWatered, notes, history];
}
