import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/serverpod_client.dart';
import '../../data/repositories/serverpod_task_repository.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/task_usecases.dart';
import 'task_view_provider.dart';
import '../../../projects/presentation/providers/selected_project_provider.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);

  return ServerpodTaskRepository(client);
});

final getTasksProvider = Provider<GetTasks>((ref) {
  return GetTasks(ref.watch(taskRepositoryProvider));
});

final createTaskProvider = Provider<CreateTask>((ref) {
  return CreateTask(ref.watch(taskRepositoryProvider));
});

final completeTaskProvider = Provider<CompleteTask>((ref) {
  return CompleteTask(ref.watch(taskRepositoryProvider));
});

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  return DeleteTask(ref.watch(taskRepositoryProvider));
});

final tasksProvider = FutureProvider<List<TaskEntity>>((ref) {
  return ref.watch(getTasksProvider)();
});

final updateTaskProvider = Provider<UpdateTask>((ref) {
  return UpdateTask(
    ref.watch(taskRepositoryProvider),
  );
});

// Filtered and sorted task list
final filteredTasksProvider = Provider<AsyncValue<List<TaskEntity>>>((ref) {
  final tasksAsync = ref.watch(tasksProvider);

  final view = ref.watch(selectedTaskViewProvider);
  final priority = ref.watch(selectedPriorityProvider);
  final sort = ref.watch(selectedTaskSortProvider);
  final selectedProjectId = ref.watch(selectedProjectProvider);

  return tasksAsync.whenData((tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final filtered = tasks.where((task) {
      final dueDate = task.dueDate?.toLocal();

      final dueDay = dueDate == null
          ? null
          : DateTime(
              dueDate.year,
              dueDate.month,
              dueDate.day,
            );

      final matchesView = switch (view) {
        TaskView.all => true,

        TaskView.today =>
          !task.isCompleted && dueDay != null && dueDay == today,

        TaskView.upcoming =>
          !task.isCompleted && dueDay != null && !dueDay.isBefore(today),

        TaskView.completed => task.isCompleted,
      };

      final matchesPriority = priority == null || task.priority == priority;

      final matchesProject = switch (selectedProjectId) {
        null => true,
        -1 => task.projectId == null,
        _ => task.projectId == selectedProjectId,
      };
      // When a project is selected, show all tasks
      // belonging to that project, regardless of
      // the currently selected global task view.
      final effectiveViewMatch = selectedProjectId != null ? true : matchesView;

      return effectiveViewMatch && matchesProject && matchesPriority;
    }).toList();

    switch (sort) {
      case TaskSort.newest:
        filtered.sort((a, b) {
          final result = b.createdAt.compareTo(a.createdAt);
          return result != 0 ? result : b.id.compareTo(a.id);
        });

      case TaskSort.priority:
        filtered.sort((a, b) {
          final result = b.priority.compareTo(a.priority);
          return result != 0 ? result : b.id.compareTo(a.id);
        });

      case TaskSort.dueDate:
        filtered.sort((a, b) {
          final aDue = a.dueDate;
          final bDue = b.dueDate;

          if (aDue == null && bDue == null) {
            return b.id.compareTo(a.id);
          }
          if (aDue == null) return 1;
          if (bDue == null) return -1;

          final result = aDue.compareTo(bDue);
          return result != 0 ? result : b.id.compareTo(a.id);
        });
    }

    return filtered;
  });
});

// Statistics calculated from ALL tasks,
// regardless of the selected filter.
class TaskStatistics {
  final int total;
  final int active;
  final int completed;

  const TaskStatistics({
    required this.total,
    required this.active,
    required this.completed,
  });
}

final taskStatisticsProvider = Provider<AsyncValue<TaskStatistics>>((ref) {
  final tasksAsync = ref.watch(tasksProvider);

  return tasksAsync.whenData((tasks) {
    final completed = tasks.where((task) => task.isCompleted).length;

    return TaskStatistics(
      total: tasks.length,
      active: tasks.length - completed,
      completed: completed,
    );
  });
});

final assignTaskToProjectProvider = Provider<AssignTaskToProject>((ref) {
  return AssignTaskToProject(
    ref.watch(taskRepositoryProvider),
  );
});
