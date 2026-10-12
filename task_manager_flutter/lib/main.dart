import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Load the saved appearance before starting the app.
  await container.read(themeModeProvider.notifier).loadThemeMode();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TaskManagerApp(),
    ),
  );
}
