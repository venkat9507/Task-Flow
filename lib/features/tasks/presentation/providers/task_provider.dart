import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_all_tasks.dart';
import '../../domain/usecases/delete_completed_tasks.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/get_completed_tasks.dart';
import '../../domain/usecases/get_pending_tasks.dart';
import '../../domain/usecases/search_tasks.dart';
import '../../domain/usecases/toggle_task_completion.dart';
import '../../domain/usecases/update_task.dart';

/// Task list state
class TaskListState {
  final List<TaskEntity> tasks;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedCategoryId;
  final int? selectedPriority;
  final bool isSortedByPriority;
  final bool isSortedByDate;
  final TaskFilter filter;

  const TaskListState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategoryId,
    this.selectedPriority,
    this.isSortedByPriority = false,
    this.isSortedByDate = false,
    this.filter = TaskFilter.all,
  });

  TaskListState copyWith({
    List<TaskEntity>? tasks,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategoryId,
    int? selectedPriority,
    bool? isSortedByPriority,
    bool? isSortedByDate,
    TaskFilter? filter,
    bool clearError = false,
    bool clearCategory = false,
    bool clearPriority = false,
    bool clearSort = false,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: clearCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      selectedPriority: clearPriority
          ? null
          : (selectedPriority ?? this.selectedPriority),
      isSortedByPriority: clearSort
          ? false
          : (isSortedByPriority ?? this.isSortedByPriority),
      isSortedByDate: clearSort
          ? false
          : (isSortedByDate ?? this.isSortedByDate),
      filter: filter ?? this.filter,
    );
  }

  /// Get filtered tasks based on current state
  List<TaskEntity> get filteredTasks {
    var result = List<TaskEntity>.from(tasks);

    // Apply filter
    switch (filter) {
      case TaskFilter.pending:
        result = result.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.completed:
        result = result.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.today:
        result = result.where((t) => t.isDueToday).toList();
        break;
      case TaskFilter.overdue:
        result = result.where((t) => t.isOverdue).toList();
        break;
      case TaskFilter.highPriority:
        result = result.where((t) => t.isHighPriority).toList();
        break;
      case TaskFilter.all:
        break;
    }

    // Apply category filter
    if (selectedCategoryId != null) {
      result = result.where((t) => t.categoryId == selectedCategoryId).toList();
    }

    // Apply priority filter
    if (selectedPriority != null) {
      result = result.where((t) => t.priority == selectedPriority).toList();
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(query) ||
                (t.description?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }

    // Apply sorting
    if (isSortedByPriority) {
      result.sort((a, b) => b.priority.compareTo(a.priority));
    } else if (isSortedByDate) {
      result.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    }

    return result;
  }

  /// Get task counts
  int get totalCount => tasks.length;
  int get pendingCount => tasks.where((t) => !t.isCompleted).length;
  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get overdueCount => tasks.where((t) => t.isOverdue).length;
  int get todayCount => tasks.where((t) => t.isDueToday).length;
}

/// Task filter options
enum TaskFilter { all, pending, completed, today, overdue, highPriority }

/// Task list notifier
class TaskListNotifier extends StateNotifier<TaskListState> {
  final GetAllTasks _getAllTasks;
  // ignore: unused_field - reserved for future filtering feature
  final GetPendingTasks _getPendingTasks;
  // ignore: unused_field - reserved for future filtering feature
  final GetCompletedTasks _getCompletedTasks;
  final SearchTasks _searchTasks;
  final CreateTask _createTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final ToggleTaskCompletion _toggleTaskCompletion;
  final DeleteCompletedTasks _deleteCompletedTasks;
  final DeleteAllTasks _deleteAllTasks;

  TaskListNotifier({
    required GetAllTasks getAllTasks,
    required GetPendingTasks getPendingTasks,
    required GetCompletedTasks getCompletedTasks,
    required SearchTasks searchTasks,
    required CreateTask createTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
    required ToggleTaskCompletion toggleTaskCompletion,
    required DeleteCompletedTasks deleteCompletedTasks,
    required DeleteAllTasks deleteAllTasks,
  }) : _getAllTasks = getAllTasks,
       _getPendingTasks = getPendingTasks,
       _getCompletedTasks = getCompletedTasks,
       _searchTasks = searchTasks,
       _createTask = createTask,
       _updateTask = updateTask,
       _deleteTask = deleteTask,
       _toggleTaskCompletion = toggleTaskCompletion,
       _deleteCompletedTasks = deleteCompletedTasks,
       _deleteAllTasks = deleteAllTasks,
       super(const TaskListState());

  /// Load all tasks
  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getAllTasks();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (tasks) => state = state.copyWith(isLoading: false, tasks: tasks),
    );
  }

  /// Search tasks
  Future<void> searchTasks(String query) async {
    state = state.copyWith(searchQuery: query);

    if (query.isEmpty) {
      await loadTasks();
      return;
    }

    final result = await _searchTasks(SearchTasksParams(query: query));

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (tasks) => state = state.copyWith(tasks: tasks),
    );
  }

  /// Create a new task
  Future<bool> createTask({
    required String title,
    String? description,
    int priority = 0,
    String? categoryId,
    DateTime? dueDate,
  }) async {
    final result = await _createTask(
      CreateTaskParams(
        title: title,
        description: description,
        priority: priority,
        categoryId: categoryId,
        dueDate: dueDate,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (task) {
        state = state.copyWith(tasks: [task, ...state.tasks], clearError: true);
        return true;
      },
    );
  }

  /// Update a task
  Future<bool> updateTask(
    TaskEntity task, {
    String? title,
    String? description,
    int? priority,
    String? categoryId,
    DateTime? dueDate,
  }) async {
    final result = await _updateTask(
      UpdateTaskParams(
        task: task,
        title: title,
        description: description,
        priority: priority,
        categoryId: categoryId,
        dueDate: dueDate,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (updatedTask) {
        final updatedTasks = state.tasks.map((t) {
          return t.id == updatedTask.id ? updatedTask : t;
        }).toList();
        state = state.copyWith(tasks: updatedTasks, clearError: true);
        return true;
      },
    );
  }

  /// Delete a task
  Future<bool> deleteTask(String id) async {
    final result = await _deleteTask(DeleteTaskParams(id: id));

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (success) {
        if (success) {
          state = state.copyWith(
            tasks: state.tasks.where((t) => t.id != id).toList(),
            clearError: true,
          );
        }
        return success;
      },
    );
  }

  /// Toggle task completion
  Future<bool> toggleCompletion(String id) async {
    final result = await _toggleTaskCompletion(
      ToggleTaskCompletionParams(id: id),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (updatedTask) {
        final updatedTasks = state.tasks.map((t) {
          return t.id == updatedTask.id ? updatedTask : t;
        }).toList();
        state = state.copyWith(tasks: updatedTasks, clearError: true);
        return true;
      },
    );
  }

  /// Set filter
  void setFilter(TaskFilter filter) {
    state = state.copyWith(filter: filter);
  }

  /// Set category filter
  void setCategoryFilter(String? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategoryId: categoryId);
    }
  }

  /// Set priority filter
  void setPriorityFilter(int? priority) {
    if (priority == null) {
      state = state.copyWith(clearPriority: true);
    } else {
      state = state.copyWith(selectedPriority: priority);
    }
  }

  /// Toggle priority sort
  void togglePrioritySort() {
    state = state.copyWith(
      isSortedByPriority: !state.isSortedByPriority,
      isSortedByDate: false, // Mutually exclusive
    );
  }

  /// Toggle date sort
  void toggleDateSort() {
    state = state.copyWith(
      isSortedByDate: !state.isSortedByDate,
      isSortedByPriority: false, // Mutually exclusive
    );
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      clearCategory: true,
      clearPriority: true,
      clearSort: true,
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Delete all completed tasks
  Future<void> deleteCompletedTasks() async {
    final result = await _deleteCompletedTasks(NoParams());

    result.fold((failure) => state = state.copyWith(error: failure.message), (
      count,
    ) {
      state = state.copyWith(
        tasks: state.tasks.where((t) => !t.isCompleted).toList(),
        clearError: true,
      );
    });
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    final result = await _deleteAllTasks(NoParams());

    result.fold((failure) => state = state.copyWith(error: failure.message), (
      count,
    ) {
      state = state.copyWith(tasks: [], clearError: true);
    });
  }
}

/// Task list provider
final taskListProvider = StateNotifierProvider<TaskListNotifier, TaskListState>(
  (ref) {
    return TaskListNotifier(
      getAllTasks: getIt<GetAllTasks>(),
      getPendingTasks: getIt<GetPendingTasks>(),
      getCompletedTasks: getIt<GetCompletedTasks>(),
      searchTasks: getIt<SearchTasks>(),
      createTask: getIt<CreateTask>(),
      updateTask: getIt<UpdateTask>(),
      deleteTask: getIt<DeleteTask>(),
      toggleTaskCompletion: getIt<ToggleTaskCompletion>(),
      deleteCompletedTasks: getIt<DeleteCompletedTasks>(),
      deleteAllTasks: getIt<DeleteAllTasks>(),
    );
  },
);

/// Filtered tasks provider (derived from taskListProvider)
final filteredTasksProvider = Provider<List<TaskEntity>>((ref) {
  final taskState = ref.watch(taskListProvider);
  return taskState.filteredTasks;
});

/// Task counts provider
final taskCountsProvider = Provider<Map<String, int>>((ref) {
  final taskState = ref.watch(taskListProvider);
  return {
    'total': taskState.totalCount,
    'pending': taskState.pendingCount,
    'completed': taskState.completedCount,
    'overdue': taskState.overdueCount,
    'today': taskState.todayCount,
  };
});

/// Selected filter provider
final selectedFilterProvider = Provider<TaskFilter>((ref) {
  return ref.watch(taskListProvider).filter;
});

/// Search query provider
final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(taskListProvider).searchQuery;
});
