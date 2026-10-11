import 'package:task_manager_client/task_manager_client.dart';

import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';

class ServerpodProjectRepository implements ProjectRepository {
  final Client client;

  const ServerpodProjectRepository(this.client);

  ProjectEntity _mapProject(Project project) {
    return ProjectEntity(
      id: project.id!,
      name: project.name,
      description: project.description,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
    );
  }

  @override
  Future<List<ProjectEntity>> getProjects() async {
    final projects = await client.project.getProjects();
    return projects.map(_mapProject).toList();
  }

  @override
  Future<ProjectEntity> createProject({
    required String name,
    String? description,
  }) async {
    final project = await client.project.createProject(
      name,
      description,
    );

    return _mapProject(project);
  }

  @override
  Future<ProjectEntity?> updateProject({
    required int projectId,
    required String name,
    String? description,
  }) async {
    final project = await client.project.updateProject(
      projectId,
      name,
      description,
    );

    return project == null ? null : _mapProject(project);
  }

  @override
  Future<bool> deleteProject(int projectId) {
    return client.project.deleteProject(projectId);
  }
}
