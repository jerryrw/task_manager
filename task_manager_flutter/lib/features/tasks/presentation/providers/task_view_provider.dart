import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskView {
  all,
  today,
  upcoming,
  completed,
}

enum TaskSort {
  newest,
  priority,
  dueDate,
}

// Selected navigation view
class SelectedTaskViewNotifier extends Notifier<TaskView> {
  @override
  TaskView build() => TaskView.all;

  void setView(TaskView view) {
    state = view;
  }
}

final selectedTaskViewProvider =
    NotifierProvider<SelectedTaskViewNotifier, TaskView>(
      SelectedTaskViewNotifier.new,
    );

// Selected priority filter
class SelectedPriorityNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setPriority(int? priority) {
    state = priority;
  }
}

final selectedPriorityProvider =
    NotifierProvider<SelectedPriorityNotifier, int?>(
      SelectedPriorityNotifier.new,
    );

// Selected sort order
class SelectedTaskSortNotifier extends Notifier<TaskSort> {
  @override
  TaskSort build() => TaskSort.newest;

  void setSort(TaskSort sort) {
    state = sort;
  }
}

final selectedTaskSortProvider =
    NotifierProvider<SelectedTaskSortNotifier, TaskSort>(
      SelectedTaskSortNotifier.new,
    );
