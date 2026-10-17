import '../data/models/plant.dart';

const String plantImgPath = 'assets/images';

const List<String> plantRooms = [
  'Living room',
  'Bedroom',
  'Kitchen',
  'Bathroom',
  'Hallway',
  'Desk',
];

const List<String> plantLightLevels = ['Low', 'Medium', 'Bright'];

const List<String> plantImageChoices = [
  '$plantImgPath/monstera.jpg',
  '$plantImgPath/snake-plant.jpg',
  '$plantImgPath/fiddle-leaf.jpg',
  '$plantImgPath/succulent.jpg',
  '$plantImgPath/pothos.jpg',
  '$plantImgPath/cactus.jpg',
  '$plantImgPath/orchid.jpg',
  '$plantImgPath/fern.jpg',
  '$plantImgPath/peace-lily.jpg',
  '$plantImgPath/aloe.jpg',
];

List<Plant> buildSamplePlants() {
  final now = DateTime.now();

  List<DateTime> history(int interval, int count) => [
        for (var i = 1; i <= count; i++)
          now.subtract(Duration(days: interval * i, hours: 2)),
      ];

  Plant plant({
    required String id,
    required String name,
    required String species,
    required String room,
    required String image,
    required String light,
    required int interval,
    required int wateredDaysAgo,
    required String notes,
  }) {
    final last = now.subtract(Duration(days: wateredDaysAgo, hours: 3));
    return Plant(
      id: id,
      name: name,
      species: species,
      room: room,
      image: '$plantImgPath/$image.jpg',
      light: light,
      waterEveryDays: interval,
      lastWatered: last,
      notes: notes,
      history: [last, ...history(interval, 3)],
    );
  }

  return [
    plant(
      id: 'monstera',
      name: 'Monstera',
      species: 'Monstera deliciosa',
      room: 'Living room',
      image: 'monstera',
      light: 'Bright',
      interval: 7,
      wateredDaysAgo: 7,
      notes: 'Loves indirect light. Wipe leaves monthly to keep them glossy.',
    ),
    plant(
      id: 'snake-plant',
      name: 'Sansevieria',
      species: 'Dracaena trifasciata',
      room: 'Bedroom',
      image: 'snake-plant',
      light: 'Low',
      interval: 14,
      wateredDaysAgo: 12,
      notes: 'Very forgiving. Let the soil dry out completely between waterings.',
    ),
    plant(
      id: 'fiddle-leaf',
      name: 'Fiddle Leaf Fig',
      species: 'Ficus lyrata',
      room: 'Living room',
      image: 'fiddle-leaf',
      light: 'Bright',
      interval: 7,
      wateredDaysAgo: 9,
      notes: 'Hates being moved. Rotate a quarter turn each week.',
    ),
    plant(
      id: 'succulent',
      name: 'Echeveria',
      species: 'Echeveria elegans',
      room: 'Desk',
      image: 'succulent',
      light: 'Bright',
      interval: 14,
      wateredDaysAgo: 3,
      notes: 'Water the soil, never the rosette, to avoid rot.',
    ),
    plant(
      id: 'pothos',
      name: 'Golden Pothos',
      species: 'Epipremnum aureum',
      room: 'Kitchen',
      image: 'pothos',
      light: 'Medium',
      interval: 8,
      wateredDaysAgo: 8,
      notes: 'Trails beautifully from a shelf. Trim to keep it bushy.',
    ),
    plant(
      id: 'cactus',
      name: 'Golden Barrel',
      species: 'Echinocactus grusonii',
      room: 'Living room',
      image: 'cactus',
      light: 'Bright',
      interval: 21,
      wateredDaysAgo: 6,
      notes: 'Drought tolerant. Reduce watering to monthly in winter.',
    ),
    plant(
      id: 'orchid',
      name: 'Phalaenopsis',
      species: 'Phalaenopsis amabilis',
      room: 'Bathroom',
      image: 'orchid',
      light: 'Medium',
      interval: 10,
      wateredDaysAgo: 11,
      notes: 'Water by soaking the roots, then let it drain fully.',
    ),
    plant(
      id: 'fern',
      name: 'Boston Fern',
      species: 'Nephrolepis exaltata',
      room: 'Bathroom',
      image: 'fern',
      light: 'Medium',
      interval: 5,
      wateredDaysAgo: 5,
      notes: 'Loves humidity. Mist daily or place on a pebble tray.',
    ),
    plant(
      id: 'peace-lily',
      name: 'Peace Lily',
      species: 'Spathiphyllum wallisii',
      room: 'Hallway',
      image: 'peace-lily',
      light: 'Low',
      interval: 6,
      wateredDaysAgo: 2,
      notes: 'Droops dramatically when thirsty — a clear signal to water.',
    ),
    plant(
      id: 'aloe',
      name: 'Aloe Vera',
      species: 'Aloe barbadensis miller',
      room: 'Kitchen',
      image: 'aloe',
      light: 'Bright',
      interval: 14,
      wateredDaysAgo: 20,
      notes: 'Soak thoroughly, then let the soil dry out.',
    ),
  ];
}
