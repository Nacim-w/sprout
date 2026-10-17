import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/plant.dart';
import 'sprout_repository.dart';

class LocalSproutRepository implements SproutRepository {
  LocalSproutRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _plantsKey = 'sprout.plants';

  @override
  List<Plant>? loadPlants() {
    final raw = _prefs.getString(_plantsKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => Plant.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> savePlants(List<Plant> plants) {
    final raw = jsonEncode(plants.map((p) => p.toJson()).toList());
    return _prefs.setString(_plantsKey, raw);
  }

  @override
  String newId() => 'plant${DateTime.now().microsecondsSinceEpoch}';
}
