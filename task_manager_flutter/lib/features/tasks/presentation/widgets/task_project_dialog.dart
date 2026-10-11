import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../projects/presentation/providers/project_providers.dart';
import '../../domain/entities/task_entity.dart';

class TaskProjectSelection {
  final int? projectId;

  const TaskProjectSelection(this.projectId);
}

class TaskProjectDialog extends ConsumerStatefulWidget {
  final TaskEntity task;

  const TaskProjectDialog({
    super.key,
    required this.task,
  });

  @override
  ConsumerState<TaskProjectDialog> createState() => _TaskProjectDialogState();
}

class _TaskProjectDialogState extends ConsumerState<TaskProjectDialog> {
  int? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.task.projectId;
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);

    return AlertDialog(
      title: const Text('Assign to Project'),
      content: SizedBox(
        width: 360,
        child: projectsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Text(
            'Unable to load projects: $error',
          ),
          data: (projects) {
            final validIds = projects.map((p) => p.id).toSet();

            final dropdownValue =
                _selectedProjectId == null ||
                    validIds.contains(_selectedProjectId)
                ? _selectedProjectId
                : null;

            return DropdownButtonFormField<int>(
              key: ValueKey(dropdownValue),
              initialValue: dropdownValue,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Project',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int>(
                  value: null,
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
                setState(() {
                  _selectedProjectId = value;
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: projectsAsync.hasValue
              ? () {
                  Navigator.pop(
                    context,
                    TaskProjectSelection(_selectedProjectId),
                  );
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
