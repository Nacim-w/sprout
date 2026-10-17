import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/sample_plants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/plant.dart';
import '../../../widgets/plant_photo.dart';
import '../cubit/plants_cubit.dart';

Future<void> showPlantFormSheet(
  BuildContext context, {
  Plant? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _PlantFormSheet(existing: existing),
  );
}

class _PlantFormSheet extends StatefulWidget {
  const _PlantFormSheet({this.existing});

  final Plant? existing;

  @override
  State<_PlantFormSheet> createState() => _PlantFormSheetState();
}

class _PlantFormSheetState extends State<_PlantFormSheet> {
  late final TextEditingController _name;
  late final TextEditingController _species;
  late final TextEditingController _notes;
  late String _room;
  late String _light;
  late String _image;
  late double _interval;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _species = TextEditingController(text: e?.species ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _room = e?.room ?? plantRooms.first;
    _light = e?.light ?? 'Medium';
    _image = e?.image ?? plantImageChoices.first;
    _interval = (e?.waterEveryDays ?? 7).toDouble();
  }

  @override
  void dispose() {
    _name.dispose();
    _species.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Your plant needs a name.');
      return;
    }
    final cubit = context.read<PlantsCubit>();
    if (widget.existing != null) {
      cubit.updatePlant(
        widget.existing!,
        name: name,
        species: _species.text.trim(),
        room: _room,
        image: _image,
        light: _light,
        waterEveryDays: _interval.round(),
        notes: _notes.text.trim(),
      );
    } else {
      cubit.addPlant(
        name: name,
        species: _species.text.trim(),
        room: _room,
        image: _image,
        light: _light,
        waterEveryDays: _interval.round(),
        notes: _notes.text.trim(),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 4, 24, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing == null ? 'NEW PLANT' : 'EDIT PLANT',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
                color: AppColors.leaf,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.existing == null
                  ? 'Welcome a new plant'
                  : 'Update ${widget.existing!.name}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Plant name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _species,
              textCapitalization: TextCapitalization.words,
              decoration:
                  const InputDecoration(hintText: 'Species (optional)'),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('ROOM'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plantRooms.map((r) {
                final active = r == _room;
                return _Choice(
                  label: r,
                  active: active,
                  onTap: () => setState(() => _room = r),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('LIGHT'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: plantLightLevels.map((l) {
                final active = l == _light;
                return _Choice(
                  label: l,
                  active: active,
                  icon: Icons.wb_sunny_outlined,
                  onTap: () => setState(() => _light = l),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const _FieldLabel('WATER EVERY'),
                const Spacer(),
                Text(
                  '${_interval.round()} days',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.leaf,
                  ),
                ),
              ],
            ),
            Slider(
              value: _interval,
              min: 1,
              max: 30,
              divisions: 29,
              label: '${_interval.round()} days',
              onChanged: (v) => setState(() => _interval = v),
            ),
            const SizedBox(height: 6),
            const _FieldLabel('PHOTO'),
            const SizedBox(height: 10),
            SizedBox(
              height: 84,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: plantImageChoices.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final img = plantImageChoices[i];
                  final selected = img == _image;
                  return GestureDetector(
                    onTap: () => setState(() => _image = img),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? AppColors.leaf : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 76,
                          height: 76,
                          child: PlantPhoto(asset: img),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _notes,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  const InputDecoration(hintText: 'Care notes (optional)'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.terracotta,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56)),
              child: Text(
                  widget.existing == null ? 'Add plant' : 'Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
        color: AppColors.inkSoft,
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.leaf : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? AppColors.leaf : AppColors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 15,
                  color: active ? Colors.white : AppColors.inkSoft),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: active ? Colors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
