import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/sprout_repository.dart';
import 'features/layout/app_shell.dart';
import 'features/plants/cubit/plants_cubit.dart';

class SproutApp extends StatelessWidget {
  const SproutApp({super.key, required this.repository});

  final SproutRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlantsCubit(repository),
      child: MaterialApp(
        title: 'Sprout',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AppShell(),
      ),
    );
  }
}
