import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  final ValueChanged<bool> onCompleted;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isBusy;

  const TaskTile({
    super.key,
    required this.task,
    required this.onCompleted,
    required this.onDelete,
    required this.onEdit,
    this.isBusy = false,
  });

  String get priorityLabel {
    switch (task.priority) {
      case 2:
        return 'Urgent';
      case 1:
        return 'High';
      default:
        return 'Normal';
    }
  }

  Color priorityColor(BuildContext context) {
    switch (task.priority) {
      case 2:
        return Theme.of(context).colorScheme.error;
      case 1:
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dueDate = task.dueDate?.toLocal();

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: isBusy
                ? null
                : (value) {
                    if (value != null) {
                      onCompleted(value);
                    }
                  },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                Chip(
                  label: Text(priorityLabel),
                  labelStyle: TextStyle(
                    color: priorityColor(context),
                    fontSize: 12,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                if (dueDate != null)
                  Chip(
                    avatar: const Icon(
                      Icons.calendar_today,
                      size: 15,
                    ),
                    label: Text(
                      MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(dueDate),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Edit task',
                onPressed: isBusy ? null : onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
              ),
              IconButton(
                tooltip: 'Delete task',
                onPressed: isBusy ? null : onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
