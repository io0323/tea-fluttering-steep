    １import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'features/brewing/data/models/brewing_session_model.dart';
import 'features/brewing/data/models/tea_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    schemas: [
      TeaModelSchema,
      BrewingSessionModelSchema,
    ],
    directory: dir.path,
  );
  runApp(ProviderScope(
    overrides: [
      brewingRepositoryProvider.overrideWithValue(BrewingRepositoryImpl(isar)),
    ],
    child: const TeaSteepingApp(),
  ));
}

class TeaSteepingApp extends StatelessWidget {
  const TeaSteepingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tea Fluttering Steep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
