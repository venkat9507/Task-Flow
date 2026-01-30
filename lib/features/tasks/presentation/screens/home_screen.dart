import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../providers/task_provider.dart';
import '../widgets/empty_tasks_widget.dart';
import '../widgets/task_card.dart';

/// Home screen with task list
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskListProvider.notifier).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskState = ref.watch(taskListProvider);
    final filteredTasks = ref.watch(filteredTasksProvider);
    final taskCounts = ref.watch(taskCountsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar.large(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Task Flow'),
                Text(
                  '${taskCounts['pending'] ?? 0} tasks pending',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            actions: [
              // Search button
              IconButton(
                icon: const Icon(Iconsax.search_normal),
                onPressed: () => _showSearchSheet(context),
                tooltip: 'Search',
              ),
              // Filter button
              IconButton(
                icon: Icon(
                  Iconsax.filter,
                  color:
                      (taskState.selectedCategoryId != null ||
                          taskState.selectedPriority != null ||
                          taskState.isSortedByPriority ||
                          taskState.isSortedByDate)
                      ? theme.colorScheme.primary
                      : null,
                ),
                onPressed: () => _showFilterSheet(context),
                tooltip: 'Filter',
              ),
              // Settings button
              IconButton(
                icon: const Icon(Iconsax.setting_2),
                onPressed: () => context.push(AppRoutes.settings),
                tooltip: 'Settings',
              ),
            ],
          ),

          // Filter chips
          SliverToBoxAdapter(child: _buildFilterChips(context)),

          // Task list
          if (taskState.isLoading)
            SliverFillRemaining(child: TaskListSkeleton())
          else if (taskState.error != null)
            SliverFillRemaining(
              child: _buildErrorState(context, taskState.error!),
            )
          else if (filteredTasks.isEmpty)
            SliverFillRemaining(
              child: EmptyTasksWidget(
                title: _getEmptyTitle(taskState.filter),
                subtitle: _getEmptySubtitle(taskState.filter),
                onAddTask: () => context.push(AppRoutes.addTask),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 88),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final task = filteredTasks[index];
                  return TaskCard(
                        task: task,
                        onTap: () =>
                            context.push('${AppRoutes.editTask}/${task.id}'),
                        onToggle: () {
                          HapticUtils.toggle();
                          ref
                              .read(taskListProvider.notifier)
                              .toggleCompletion(task.id);
                        },
                        onDelete: () {
                          HapticUtils.delete();
                          ref
                              .read(taskListProvider.notifier)
                              .deleteTask(task.id);
                        },
                      )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 50 * index),
                        duration: 300.ms,
                      )
                      .slideX(
                        begin: 0.1,
                        end: 0,
                        delay: Duration(milliseconds: 50 * index),
                        duration: 300.ms,
                        curve: Curves.easeOutCubic,
                      );
                }, childCount: filteredTasks.length),
              ),
            ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton.extended(
                onPressed: () => context.push(AppRoutes.addTask),
                icon: const Icon(Iconsax.add),
                label: const Text('Add Task'),
              )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideY(begin: 1, end: 0, curve: Curves.easeOutBack),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final selectedFilter = ref.watch(selectedFilterProvider);
    final theme = Theme.of(context);

    final filters = [
      (TaskFilter.all, 'All', Iconsax.task),
      (TaskFilter.pending, 'Pending', Iconsax.clock),
      (TaskFilter.completed, 'Done', Iconsax.tick_circle),
      (TaskFilter.today, 'Today', Iconsax.calendar_1),
      (TaskFilter.overdue, 'Overdue', Iconsax.warning_2),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(filter.$2),
              avatar: Icon(
                filter.$3,
                size: 18,
                color: isSelected
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
              onSelected: (_) {
                ref.read(taskListProvider.notifier).setFilter(filter.$1);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.read(taskListProvider.notifier).loadTasks(),
              icon: const Icon(Iconsax.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: Icon(Iconsax.search_normal),
                ),
                onChanged: (value) {
                  ref.read(taskListProvider.notifier).searchTasks(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final theme = Theme.of(context);
          final taskState = ref.watch(taskListProvider);

          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter Tasks', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    Iconsax.calendar_1,
                    color: taskState.isSortedByDate
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  title: Text(
                    'Sort by Due Date',
                    style: TextStyle(
                      color: taskState.isSortedByDate
                          ? theme.colorScheme.primary
                          : null,
                      fontWeight: taskState.isSortedByDate
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: taskState.isSortedByDate
                      ? Icon(
                          Iconsax.tick_circle,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    ref.read(taskListProvider.notifier).toggleDateSort();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Iconsax.sort,
                    color: taskState.isSortedByPriority
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  title: Text(
                    'Sort by Priority',
                    style: TextStyle(
                      color: taskState.isSortedByPriority
                          ? theme.colorScheme.primary
                          : null,
                      fontWeight: taskState.isSortedByPriority
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: taskState.isSortedByPriority
                      ? Icon(
                          Iconsax.tick_circle,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    ref.read(taskListProvider.notifier).togglePrioritySort();
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Iconsax.close_circle),
                  title: const Text('Clear Filters'),
                  onTap: () {
                    ref.read(taskListProvider.notifier).clearFilters();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getEmptyTitle(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.pending:
        return 'All caught up!';
      case TaskFilter.completed:
        return 'No completed tasks';
      case TaskFilter.today:
        return 'Nothing due today';
      case TaskFilter.overdue:
        return 'Nothing overdue';
      case TaskFilter.highPriority:
        return 'No high priority tasks';
      case TaskFilter.all:
        return 'No tasks yet';
    }
  }

  String _getEmptySubtitle(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.pending:
        return 'Great job! All your tasks are completed.';
      case TaskFilter.completed:
        return 'Complete some tasks to see them here.';
      case TaskFilter.today:
        return 'Set due dates on tasks to see them here.';
      case TaskFilter.overdue:
        return 'Keep up the good work!';
      case TaskFilter.highPriority:
        return 'Mark tasks as high priority to see them here.';
      case TaskFilter.all:
        return 'Add your first task to get started.';
    }
  }
}
