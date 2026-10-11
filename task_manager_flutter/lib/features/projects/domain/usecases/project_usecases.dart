import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetProjects {
  final ProjectRepository repository;

  const GetProjects(this.repository);

  Future<List<ProjectEntity>> call() {
    return repository.getProjects();
  }
}

class CreateProject {
  final ProjectRepository repository;

  const CreateProject(this.repository);

  Future<ProjectEntity> call({
    required String name,
    String? description,
  }) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Project name cannot be empty');
    }

    return repository.createProject(
      name: trimmedName,
      description: description?.trim(),
    );
  }
}

class UpdateProject {
  final ProjectRepository repository;

  const UpdateProject(this.repository);

  Future<ProjectEntity?> call({
    required int projectId,
    required String name,
    String? description,
  }) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Project name cannot be empty');
    }

    return repository.updateProject(
      projectId: projectId,
      name: trimmedName,
      description: description?.trim(),
    );
  }
}

class DeleteProject {
  final ProjectRepository repository;

  const DeleteProject(this.repository);

  Future<bool> call(int projectId) {
    return repository.deleteProject(projectId);
  }
}
