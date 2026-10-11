import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class TaskEndpoint extends Endpoint {
  Future<Task> createTask(
    Session session,
    String title,
  ) async {
    if (title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }

    final now = DateTime.now().toUtc();

    final task = Task(
      title: title,
      isCompleted: false,
      priority: 0,
      createdAt: now,
      updatedAt: now,
    );

    return Task.db.insertRow(session, task);
  }

  Future<List<Task>> getTasks(
    Session session,
  ) async {
    final tasks = await Task.db.find(session);

    tasks.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return tasks;
  }

  Future<Task?> getTask(
    Session session,
    int taskId,
  ) async {
    return Task.db.findById(session, taskId);
  }

  Future<Task?> setCompleted(
    Session session,
    int taskId,
    bool completed,
  ) async {
    final task = await Task.db.findById(
      session,
      taskId,
    );

    if (task == null) return null;

    task.isCompleted = completed;
    task.updatedAt = DateTime.now().toUtc();

    return Task.db.updateRow(session, task);
  }

  Future<Task?> updateTask(
    Session session,
    int taskId,
    String title,
    String? description,
    int priority,
    DateTime? dueDate,
  ) async {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw ArgumentError(
        'Task title cannot be empty',
      );
    }

    if (priority < 0 || priority > 2) {
      throw ArgumentError(
        'Priority must be between 0 and 2',
      );
    }

    final task = await Task.db.findById(
      session,
      taskId,
    );

    if (task == null) {
      return null;
    }

    task.title = trimmedTitle;
    task.description = description;
    task.priority = priority;
    task.dueDate = dueDate?.toUtc();
    task.updatedAt = DateTime.now().toUtc();

    return Task.db.updateRow(session, task);
  }

  Future<bool> deleteTask(
    Session session,
    int taskId,
  ) async {
    final deleted = await Task.db.deleteWhere(
      session,
      where: (t) => t.id.equals(taskId),
    );

    return deleted.isNotEmpty;
  }

  Future<Task?> assignTaskToProject(
    Session session,
    int taskId,
    int? projectId,
  ) async {
    return session.db.transaction((transaction) async {
      final task = await Task.db.findById(
        session,
        taskId,
        transaction: transaction,
      );

      if (task == null) {
        return null;
      }

      if (projectId != null) {
        final project = await Project.db.findById(
          session,
          projectId,
          transaction: transaction,
        );

        if (project == null) {
          throw ArgumentError(
            'Project does not exist: $projectId',
          );
        }
      }

      task.projectId = projectId;
      task.updatedAt = DateTime.now().toUtc();

      return Task.db.updateRow(
        session,
        task,
        transaction: transaction,
      );
    });
  }
}
