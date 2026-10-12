import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';
import '../providers/task_view_provider.dart';
import '../widgets/task_editor_dialog.dart';
import '../widgets/task_filter_bar.dart';
import '../widgets/task_sidebar.dart';
import '../widgets/task_statistics_bar.dart';
import '../widgets/task_tile.dart';

import '../../../projects/presentation/providers/project_providers.dart';
import '../../../projects/presentation/providers/selected_project_provider.dart';
import '../widgets/task_project_dialog.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final _titleController = TextEditingController();
  final Set<int> _busyTaskIds = {};

  bool _isCreating = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _refreshTasks() {
    ref.invalidate(tasksProvider);
  }

  void _showError(Object error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _assignTaskToProject(TaskEntity task) async {
    if (_busyTaskIds.contains(task.id)) return;

    final selection = await showDialog<TaskProjectSelection>(
      context: context,
      builder: (_) => TaskProjectDialog(task: task),
    );

    if (selection == null || !mounted) return;

    setState(() => _busyTaskIds.add(task.id));

    try {
      final updated = await ref.read(assignTaskToProjectProvider)(
        taskId: task.id,
        projectId: selection.projectId,
      );

      if (updated == null) {
        throw StateError('Task not found');
      }

      if (!mounted) return;

      ref.invalidate(tasksProvider);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _busyTaskIds.remove(task.id));
      }
    }
  }

  Future<void> _createTask() async {
    final title = _titleController.text.trim();

    if (title.isEmpty || _isCreating) return;

    // Capture the selected project before creating the task.
    final selectedProjectId = ref.read(
      selectedProjectProvider,
    );

    setState(() => _isCreating = true);

    try {
      // Create the task and get its ID.
      final newTask = await ref.read(
        createTaskProvider,
      )(title);

      // Assign the new task to the selected project.
      // null = global task view
      // -1 = Unassigned
      // positive ID = actual project
      if (selectedProjectId != null && selectedProjectId > 0) {
        final assigned =
            await ref.read(
              assignTaskToProjectProvider,
            )(
              taskId: newTask.id,
              projectId: selectedProjectId,
            );

        if (assigned == null) {
          throw StateError(
            'Task created, but project assignment failed',
          );
        }
      }

      if (!mounted) return;

      // Clear the input after successful creation.
      _titleController.clear();

      // Refresh the task list and project counts.
      _refreshTasks();
    } catch (error) {
      if (mounted) {
        _showError(error);
      }
    } finally {
      if (mounted) {
        // Refresh even if project assignment failed:
        // the task may already have been created.
        _refreshTasks();

        setState(() => _isCreating = false);
      }
    }
  }

  Future<void> _setCompleted(
    int taskId,
    bool completed,
  ) async {
    if (_busyTaskIds.contains(taskId)) return;

    setState(() => _busyTaskIds.add(taskId));

    try {
      await ref.read(completeTaskProvider)(
        taskId,
        completed,
      );

      if (!mounted) return;

      _refreshTasks();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _busyTaskIds.remove(taskId));
      }
    }
  }

  Future<void> _deleteTask(int taskId) async {
    if (_busyTaskIds.contains(taskId)) return;

    setState(() => _busyTaskIds.add(taskId));

    try {
      final deleted = await ref.read(deleteTaskProvider)(taskId);

      if (!mounted) return;

      if (!deleted) {
        throw StateError('Task not found');
      }

      _refreshTasks();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _busyTaskIds.remove(taskId));
      }
    }
  }

  Future<void> _editTask(TaskEntity task) async {
    if (_busyTaskIds.contains(task.id)) return;

    final result = await showDialog<TaskEditResult>(
      context: context,
      builder: (context) => TaskEditorDialog(task: task),
    );

    if (result == null || !mounted) return;

    setState(() => _busyTaskIds.add(task.id));

    try {
      final updated = await ref.read(updateTaskProvider)(
        taskId: task.id,
        title: result.title,
        description: result.description,
        priority: result.priority,
        dueDate: result.dueDate,
      );

      if (!mounted) return;

      if (updated == null) {
        throw StateError('Task not found');
      }

      // Update the project only when it has changed.
      if (result.projectId != task.projectId) {
        final assigned =
            await ref.read(
              assignTaskToProjectProvider,
            )(
              taskId: task.id,
              projectId: result.projectId,
            );

        if (assigned == null) {
          throw StateError(
            'Task was updated, but project assignment failed',
          );
        }
      }

      if (!mounted) return;

      _refreshTasks();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _busyTaskIds.remove(task.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(filteredTasksProvider);
    final selectedView = ref.watch(selectedTaskViewProvider);

    final selectedProjectId = ref.watch(selectedProjectProvider);
    final projectsAsync = ref.watch(projectsProvider);

    final selectedProject = selectedProjectId == null
        ? null
        : projectsAsync.value
              ?.where(
                (project) => project.id == selectedProjectId,
              )
              .firstOrNull;

    final title = selectedProjectId == -1
        ? 'Unassigned'
        : selectedProjectId != null
        ? selectedProject?.name ?? 'Project'
        : switch (selectedView) {
            TaskView.all => 'All Tasks',
            TaskView.today => 'Today',
            TaskView.upcoming => 'Upcoming',
            TaskView.completed => 'Completed',
          };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Refresh tasks',
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTasks,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 850;

          final content = Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 950),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TaskStatisticsBar(),
                    const SizedBox(height: 20),
                    _buildTaskInput(),
                    const SizedBox(height: 16),
                    const TaskFilterBar(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: tasksAsync.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stack) => _buildErrorState(error),
                        data: (tasks) {
                          if (tasks.isEmpty) {
                            return _buildEmptyState();
                          }

                          return ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];

                              return Row(
                                children: [
                                  Expanded(
                                    child: TaskTile(
                                      task: task,
                                      isBusy: _busyTaskIds.contains(task.id),
                                      onCompleted: (value) =>
                                          _setCompleted(task.id, value),
                                      onEdit: () => _editTask(task),
                                      onDelete: () => _deleteTask(task.id),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Assign to project',
                                    icon: Icon(
                                      task.projectId == null
                                          ? Icons.folder_outlined
                                          : Icons.folder,
                                    ),
                                    onPressed: _busyTaskIds.contains(task.id)
                                        ? null
                                        : () => _assignTaskToProject(task),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          if (!isDesktop) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: projectsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (error, stack) => TextButton(
                      onPressed: () => ref.invalidate(projectsProvider),
                      child: const Text('Retry loading projects'),
                    ),
                    data: (projects) {
                      final validProjectId =
                          selectedProjectId == -1 ||
                              projects.any(
                                (project) => project.id == selectedProjectId,
                              )
                          ? selectedProjectId
                          : null;

                      return DropdownButtonFormField<int>(
                        key: ValueKey(validProjectId),
                        initialValue: validProjectId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Project',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('All task views'),
                          ),
                          const DropdownMenuItem<int>(
                            value: -1,
                            child: Text('Unassigned'),
                          ),
                          ...projects.map(
                            (project) => DropdownMenuItem<int>(
                              value: project.id,
                              child: Text(project.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          ref
                              .read(selectedProjectProvider.notifier)
                              .selectProject(value);
                        },
                      );
                    },
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: TaskView.values.map((view) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        child: ChoiceChip(
                          label: Text(_viewLabel(view)),
                          selected:
                              selectedProjectId == null && selectedView == view,
                          onSelected: (_) {
                            ref
                                .read(selectedProjectProvider.notifier)
                                .clearSelection();

                            ref
                                .read(selectedTaskViewProvider.notifier)
                                .setView(view);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(child: content),
              ],
            );
          }

          return Row(
            children: [
              const TaskSidebar(),
              const VerticalDivider(width: 1),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }

  String _viewLabel(TaskView view) {
    return switch (view) {
      TaskView.all => 'All Tasks',
      TaskView.today => 'Today',
      TaskView.upcoming => 'Upcoming',
      TaskView.completed => 'Completed',
    };
  }

  Widget _buildTaskInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'New task',
              hintText: 'What needs to be done?',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.add_task),
            ),
            onSubmitted: (_) => _createTask(),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: _isCreating ? null : _createTask,
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 56,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks to display',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try another view or change your filters.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          const Text('Failed to load tasks'),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _refreshTasks,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
