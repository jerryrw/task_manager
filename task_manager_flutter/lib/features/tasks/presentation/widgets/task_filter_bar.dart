import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_view_provider.dart';

class TaskFilterBar extends ConsumerWidget {
  const TaskFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priority = ref.watch(selectedPriorityProvider);
    final sort = ref.watch(selectedTaskSortProvider);

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DropdownButton<int?>(
          value: priority,
          items: const [
            DropdownMenuItem<int?>(
              value: null,
              child: Text('All Priorities'),
            ),
            DropdownMenuItem<int?>(
              value: 0,
              child: Text('Normal'),
            ),
            DropdownMenuItem<int?>(
              value: 1,
              child: Text('High'),
            ),
            DropdownMenuItem<int?>(
              value: 2,
              child: Text('Urgent'),
            ),
          ],
          onChanged: (value) {
            ref.read(selectedPriorityProvider.notifier).setPriority(value);
          },
        ),
        DropdownButton<TaskSort>(
          value: sort,
          items: const [
            DropdownMenuItem(
              value: TaskSort.newest,
              child: Text('Newest First'),
            ),
            DropdownMenuItem(
              value: TaskSort.priority,
              child: Text('Priority First'),
            ),
            DropdownMenuItem(
              value: TaskSort.dueDate,
              child: Text('Due Date First'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              ref.read(selectedTaskSortProvider.notifier).setSort(value);
            }
          },
        ),
      ],
    );
  }
}
