import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task_entity.dart';
import '../../../projects/presentation/providers/project_providers.dart';

class TaskEditResult {
  final String title;
  final String? description;
  final int priority;
  final DateTime? dueDate;
  final int? projectId;

  const TaskEditResult({
    required this.title,
    this.description,
    required this.priority,
    this.dueDate,
    this.projectId,
  });
}

class TaskEditorDialog extends ConsumerStatefulWidget {
  final TaskEntity task;

  const TaskEditorDialog({
    super.key,
    required this.task,
  });

  @override
  ConsumerState<TaskEditorDialog> createState() => _TaskEditorDialogState();
}

class _TaskEditorDialogState extends ConsumerState<TaskEditorDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late int _priority;
  DateTime? _dueDate;
  int? _projectId;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.task.title,
    );

    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );

    _priority = widget.task.priority;
    _dueDate = widget.task.dueDate?.toLocal();
    _projectId = widget.task.projectId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() => _dueDate = selected);
    }
  }

  void _save() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title is required'),
        ),
      );
      return;
    }

    final description = _descriptionController.text.trim();

    Navigator.of(context).pop(
      TaskEditResult(
        title: title,
        description: description.isEmpty ? null : description,
        priority: _priority,
        dueDate: _dueDate,
        projectId: _projectId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);

    return AlertDialog(
      title: const Text('Edit Task'),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                initialValue: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Normal'),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('High'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Urgent'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _priority = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Project assignment
              projectsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Unable to load projects'),
                    TextButton(
                      onPressed: () => ref.invalidate(projectsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
                data: (projects) {
                  final validProjectId =
                      projects.any(
                        (project) => project.id == _projectId,
                      )
                      ? _projectId
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
                        child: Text('Unassigned'),
                      ),
                      ...projects.map(
                        (project) => DropdownMenuItem<int>(
                          value: project.id,
                          child: Text(
                            project.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _projectId = value);
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? 'No due date'
                          : MaterialLocalizations.of(
                              context,
                            ).formatMediumDate(_dueDate!),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _selectDueDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Choose'),
                  ),
                  if (_dueDate != null)
                    IconButton(
                      tooltip: 'Clear due date',
                      onPressed: () {
                        setState(() => _dueDate = null);
                      },
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: projectsAsync.hasValue ? _save : null,
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}
