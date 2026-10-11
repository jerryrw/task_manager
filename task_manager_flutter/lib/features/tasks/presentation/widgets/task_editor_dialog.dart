import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';

class TaskEditResult {
  final String title;
  final String? description;
  final int priority;
  final DateTime? dueDate;

  const TaskEditResult({
    required this.title,
    this.description,
    required this.priority,
    this.dueDate,
  });
}

class TaskEditorDialog extends StatefulWidget {
  final TaskEntity task;

  const TaskEditorDialog({
    super.key,
    required this.task,
  });

  @override
  State<TaskEditorDialog> createState() => _TaskEditorDialogState();
}

class _TaskEditorDialogState extends State<TaskEditorDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late int _priority;
  DateTime? _dueDate;

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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(
                      Icons.calendar_today,
                    ),
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
          onPressed: _save,
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}
