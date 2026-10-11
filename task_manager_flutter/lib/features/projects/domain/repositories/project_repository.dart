import '../entities/project_entity.dart';

abstract class ProjectRepository {
  Future<List<ProjectEntity>> getProjects();

  Future<ProjectEntity> createProject({
    required String name,
    String? description,
  });

  Future<ProjectEntity?> updateProject({
    required int projectId,
    required String name,
    String? description,
  });

  Future<bool> deleteProject(int projectId);
}
