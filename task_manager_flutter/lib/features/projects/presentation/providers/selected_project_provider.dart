import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedProjectNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void selectProject(int? projectId) {
    state = projectId;
  }

  void clearSelection() {
    state = null;
  }
}

final selectedProjectProvider = NotifierProvider<SelectedProjectNotifier, int?>(
  SelectedProjectNotifier.new,
);
