import '../models/plant.dart';

abstract class SproutRepository {
  List<Plant>? loadPlants();
  Future<void> savePlants(List<Plant> plants);
  String newId();
}
