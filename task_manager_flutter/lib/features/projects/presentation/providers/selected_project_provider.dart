import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedProjectNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  // null = global task views
  // -1 = unassigned tasks
  // positive integer = selected project ID
  void selectProject(int? projectId) {
    state = projectId;
  }

  void selectUnassigned() {
    state = -1;
  }

  void clearSelection() {
    state = null;
  }
}

final selectedProjectProvider = NotifierProvider<SelectedProjectNotifier, int?>(
  SelectedProjectNotifier.new,
);
