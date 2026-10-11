import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/project_entity.dart';
import '../providers/project_providers.dart';
import '../providers/selected_project_provider.dart';
import 'project_dialog.dart';
import '../../../tasks/presentation/providers/task_providers.dart';
import '../../../tasks/presentation/providers/task_view_provider.dart';

class ProjectSidebarSection extends ConsumerStatefulWidget {
  const ProjectSidebarSection({super.key});

  @override
  ConsumerState<ProjectSidebarSection> createState() =>
      _ProjectSidebarSectionState();
}

class _ProjectSidebarSectionState extends ConsumerState<ProjectSidebarSection> {
  bool _busy = false;

  void _showError(Object error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project error: $error')),
    );
  }

  Future<void> _createProject() async {
    final result = await showDialog<ProjectDialogResult>(
      context: context,
      builder: (_) => const ProjectDialog(),
    );

    if (result == null || !mounted) return;

    setState(() => _busy = true);

    try {
      final project = await ref.read(createProjectProvider)(
        name: result.name,
        description: result.description,
      );

      if (!mounted) return;

      ref.invalidate(projectsProvider);
      ref.read(selectedProjectProvider.notifier).selectProject(project.id);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _editProject(ProjectEntity project) async {
    final result = await showDialog<ProjectDialogResult>(
      context: context,
      builder: (_) => ProjectDialog(project: project),
    );

    if (result == null || !mounted) return;

    setState(() => _busy = true);

    try {
      final updated = await ref.read(updateProjectProvider)(
        projectId: project.id,
        name: result.name,
        description: result.description,
      );

      if (updated == null) {
        throw StateError('Project not found');
      }

      if (!mounted) return;
      ref.invalidate(projectsProvider);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteProject(ProjectEntity project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project?'),
        content: Text(
          'Delete "${project.name}"? Its tasks will '
          'be kept but become unassigned.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);

    try {
      final deleted = await ref.read(deleteProjectProvider)(project.id);

      if (!deleted) {
        throw StateError('Project not found');
      }

      if (!mounted) return;

      if (ref.read(selectedProjectProvider) == project.id) {
        ref.read(selectedProjectProvider.notifier).clearSelection();
        ref.read(selectedTaskViewProvider.notifier).setView(TaskView.all);
      }

      ref.invalidate(projectsProvider);
      ref.invalidate(tasksProvider);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);
    final selectedId = ref.watch(selectedProjectProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'PROJECTS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'New project',
                onPressed: _busy ? null : _createProject,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        projectsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text('Unable to load projects'),
                TextButton(
                  onPressed: () => ref.invalidate(projectsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (projects) {
            if (projects.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No projects yet'),
              );
            }

            return Column(
              children: projects.map((project) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: ListTile(
                    dense: true,
                    selected: selectedId == project.id,
                    selectedTileColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(
                      project.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      ref
                          .read(selectedProjectProvider.notifier)
                          .selectProject(project.id);
                    },
                    trailing: PopupMenuButton<String>(
                      enabled: !_busy,
                      tooltip: 'Project options',
                      onSelected: (action) {
                        if (action == 'edit') {
                          _editProject(project);
                        } else if (action == 'delete') {
                          _deleteProject(project);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
