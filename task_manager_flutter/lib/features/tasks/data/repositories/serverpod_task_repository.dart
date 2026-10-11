import 'package:task_manager_client/task_manager_client.dart' as serverpod;

import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

class ServerpodTaskRepository implements TaskRepository {
  final serverpod.Client client;

  ServerpodTaskRepository(this.client);

  TaskEntity _mapTask(serverpod.Task task) {
    return TaskEntity(
      id: task.id!,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      priority: task.priority,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      projectId: task.projectId,
    );
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    final tasks = await client.task.getTasks();
    return tasks.map(_mapTask).toList();
  }

  @override
  Future<TaskEntity> createTask(String title) async {
    final task = await client.task.createTask(title);
    return _mapTask(task);
  }

  @override
  Future<TaskEntity?> setCompleted(
    int taskId,
    bool completed,
  ) async {
    final task = await client.task.setCompleted(
      taskId,
      completed,
    );

    return task == null ? null : _mapTask(task);
  }

  @override
  Future<bool> deleteTask(int taskId) {
    return client.task.deleteTask(taskId);
  }

  @override
  Future<TaskEntity?> updateTask({
    required int taskId,
    required String title,
    String? description,
    required int priority,
    DateTime? dueDate,
  }) async {
    final task = await client.task.updateTask(
      taskId,
      title,
      description,
      priority,
      dueDate,
    );

    return task == null ? null : _mapTask(task);
  }

  @override
  Future<TaskEntity?> assignTaskToProject({
    required int taskId,
    required int? projectId,
  }) async {
    final task = await client.task.assignTaskToProject(
      taskId,
      projectId,
    );

    return task == null ? null : _mapTask(task);
  }
}
