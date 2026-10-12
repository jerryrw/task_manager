import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_view_provider.dart';
import '../../../projects/presentation/providers/selected_project_provider.dart';
import '../../../projects/presentation/widgets/project_sidebar_section.dart';
import '../../../../core/theme/theme_provider.dart';

class TaskSidebar extends ConsumerWidget {
  const TaskSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedView = ref.watch(selectedTaskViewProvider);
    final selectedProject = ref.watch(selectedProjectProvider);
    final colors = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);

    return Material(
      color: colors.surfaceContainerLow,
      child: SizedBox(
        width: 240,
        child: Column(
          children: [
            // Scrollable sidebar content
            Expanded(
              child: ListView(
                children: [
                  // Application header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      28,
                      20,
                      24,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Task Manager',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Built-in navigation
                  _navItem(
                    context,
                    ref,
                    label: 'All Tasks',
                    icon: Icons.list_alt,
                    view: TaskView.all,
                    selected: selectedProject == null ? selectedView : null,
                  ),
                  _navItem(
                    context,
                    ref,
                    label: 'Today',
                    icon: Icons.today,
                    view: TaskView.today,
                    selected: selectedProject == null ? selectedView : null,
                  ),
                  _navItem(
                    context,
                    ref,
                    label: 'Upcoming',
                    icon: Icons.calendar_month,
                    view: TaskView.upcoming,
                    selected: selectedProject == null ? selectedView : null,
                  ),
                  _navItem(
                    context,
                    ref,
                    label: 'Completed',
                    icon: Icons.check_circle_outline,
                    view: TaskView.completed,
                    selected: selectedProject == null ? selectedView : null,
                  ),

                  // Project navigation
                  const Divider(height: 24),
                  const ProjectSidebarSection(),
                ],
              ),
            ),

            // Footer stays at the bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Column(
                children: [
                  DropdownButtonFormField<ThemeMode>(
                    initialValue: themeMode,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Appearance',
                      prefixIcon: Icon(Icons.palette_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(themeModeProvider.notifier).setThemeMode(mode);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Task Manager • Desktop',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required IconData icon,
    required TaskView view,
    required TaskView? selected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child: ListTile(
        selected: selected == view,
        selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(icon),
        title: Text(label),
        onTap: () {
          // Clear any selected project
          ref.read(selectedProjectProvider.notifier).clearSelection();

          // Switch to the selected task view
          ref.read(selectedTaskViewProvider.notifier).setView(view);
        },
      ),
    );
  }
}
