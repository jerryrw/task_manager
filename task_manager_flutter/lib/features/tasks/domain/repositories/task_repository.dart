import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();

  Future<TaskEntity> createTask(String title);

  Future<TaskEntity?> setCompleted(
    int taskId,
    bool completed,
  );

  Future<bool> deleteTask(int taskId);

  Future<TaskEntity?> updateTask({
    required int taskId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  });

  Future<TaskEntity?> assignTaskToProject({
    required int taskId,
    required int? projectId,
  });
}
