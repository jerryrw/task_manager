import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_client/task_manager_client.dart';

final serverpodClientProvider = Provider<Client>((ref) {
  final client = Client(
    'http://localhost:8080/',
  );

  ref.onDispose(client.close);

  return client;
});
