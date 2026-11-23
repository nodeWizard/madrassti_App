import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/providers/providers.dart';
import 'data/mock/mock_data_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // All dummy data lives in assets/mock_data/*.json; load it once here and
  // hand the parsed repositories to the app as provider overrides, so every
  // screen can keep reading them synchronously.
  final mockData = await MockData.load();

  runApp(
    ProviderScope(
      overrides: [
        parentRepositoryProvider.overrideWithValue(mockData.parent),
        studentRepositoryProvider.overrideWithValue(mockData.student),
        teacherRepositoryProvider.overrideWithValue(mockData.teacher),
        authRepositoryProvider.overrideWithValue(mockData.auth),
      ],
      child: const MadrasstiApp(),
    ),
  );
}
