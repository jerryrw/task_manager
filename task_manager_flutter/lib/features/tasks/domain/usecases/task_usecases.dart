import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<TaskEntity>> call() {
    return repository.getTasks();
  }
}

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<TaskEntity> call(String title) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Task title cannot be empty');
    }

    return repository.createTask(title.trim());
  }
}

class CompleteTask {
  final TaskRepository repository;

  CompleteTask(this.repository);

  Future<TaskEntity?> call(
    int taskId,
    bool completed,
  ) {
    return repository.setCompleted(taskId, completed);
  }
}

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<bool> call(int taskId) {
    return repository.deleteTask(taskId);
  }
}

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<TaskEntity?> call({
    required int taskId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  }) {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw ArgumentError(
        'Task title cannot be empty',
      );
    }

    if (priority < 0 || priority > 2) {
      throw ArgumentError(
        'Invalid task priority',
      );
    }

    return repository.updateTask(
      taskId: taskId,
      title: trimmedTitle,
      description: description,
      priority: priority,
      dueDate: dueDate,
    );
  }
}

class AssignTaskToProject {
  final TaskRepository repository;

  const AssignTaskToProject(this.repository);

  Future<TaskEntity?> call({
    required int taskId,
    required int? projectId,
  }) {
    return repository.assignTaskToProject(
      taskId: taskId,
      projectId: projectId,
    );
  }
}
