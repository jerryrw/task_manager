import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../projects/data/repositories/serverpod_project_repository.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../../projects/domain/repositories/project_repository.dart';
import '../../../projects/domain/usecases/project_usecases.dart';

/* Important correction for Riverpod 3: The simple Provider declarations above are legacy-style APIs in Riverpod 3. To avoid the Provider isn't defined problem you encountered in Step 10, use this import in this file:
import 'package:flutter_riverpod/legacy.dart'
    show Provider;*/

// Import the existing provider that exposes your
// initialized Serverpod Client.
//
// Adjust this path and name to match Step 7.
import '../../../../core/network/serverpod_client.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return ServerpodProjectRepository(client);
});

final getProjectsProvider = Provider<GetProjects>((ref) {
  return GetProjects(ref.watch(projectRepositoryProvider));
});

final createProjectProvider = Provider<CreateProject>((ref) {
  return CreateProject(ref.watch(projectRepositoryProvider));
});

final updateProjectProvider = Provider<UpdateProject>((ref) {
  return UpdateProject(ref.watch(projectRepositoryProvider));
});

final deleteProjectProvider = Provider<DeleteProject>((ref) {
  return DeleteProject(ref.watch(projectRepositoryProvider));
});

class ProjectsNotifier extends AsyncNotifier<List<ProjectEntity>> {
  @override
  Future<List<ProjectEntity>> build() {
    return ref.watch(getProjectsProvider)();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final projectsProvider =
    AsyncNotifierProvider<ProjectsNotifier, List<ProjectEntity>>(
      ProjectsNotifier.new,
    );
