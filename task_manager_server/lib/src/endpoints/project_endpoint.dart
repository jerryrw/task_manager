import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ProjectEndpoint extends Endpoint {
  Future<List<Project>> getProjects(Session session) async {
    final projects = await Project.db.find(session);

    projects.sort(
      (a, b) => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
    );

    return projects;
  }

  Future<Project> createProject(
    Session session,
    String name,
    String? description,
  ) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Project name is required');
    }

    final now = DateTime.now().toUtc();

    final project = Project(
      name: trimmedName,
      description: description,
      createdAt: now,
      updatedAt: now,
    );

    return Project.db.insertRow(session, project);
  }

  Future<Project?> updateProject(
    Session session,
    int projectId,
    String name,
    String? description,
  ) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Project name is required');
    }

    final project = await Project.db.findById(
      session,
      projectId,
    );

    if (project == null) return null;

    project.name = trimmedName;
    project.description = description;
    project.updatedAt = DateTime.now().toUtc();

    return Project.db.updateRow(session, project);
  }

  Future<bool> deleteProject(
    Session session,
    int projectId,
  ) async {
    return session.db.transaction((transaction) async {
      final project = await Project.db.findById(
        session,
        projectId,
        transaction: transaction,
      );

      if (project == null) return false;

      final tasks = await Task.db.find(
        session,
        where: (t) => t.projectId.equals(projectId),
        transaction: transaction,
      );

      final now = DateTime.now().toUtc();

      for (final task in tasks) {
        task.projectId = null;
        task.updatedAt = now;

        await Task.db.updateRow(
          session,
          task,
          transaction: transaction,
        );
      }

      await Project.db.deleteRow(
        session,
        project,
        transaction: transaction,
      );

      return true;
    });
  }
}
