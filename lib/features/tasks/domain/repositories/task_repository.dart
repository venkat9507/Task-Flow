import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/task_entity.dart';

/// Abstract repository contract for Task operations
abstract class TaskRepository {
  /// Get all tasks
  Future<Either<Failure, List<TaskEntity>>> getAllTasks();

  /// Get task by ID
  Future<Either<Failure, TaskEntity?>> getTaskById(String id);

  /// Get tasks by category
  Future<Either<Failure, List<TaskEntity>>> getTasksByCategory(
    String categoryId,
  );

  /// Get tasks by priority
  Future<Either<Failure, List<TaskEntity>>> getTasksByPriority(int priority);

  /// Get completed tasks
  Future<Either<Failure, List<TaskEntity>>> getCompletedTasks();

  /// Get pending tasks
  Future<Either<Failure, List<TaskEntity>>> getPendingTasks();

  /// Get overdue tasks
  Future<Either<Failure, List<TaskEntity>>> getOverdueTasks();

  /// Get tasks due today
  Future<Either<Failure, List<TaskEntity>>> getTasksDueToday();

  /// Search tasks by query
  Future<Either<Failure, List<TaskEntity>>> searchTasks(String query);

  /// Create a new task
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);

  /// Update an existing task
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);

  /// Delete a task
  Future<Either<Failure, bool>> deleteTask(String id);

  /// Toggle task completion status
  Future<Either<Failure, TaskEntity>> toggleTaskCompletion(String id);

  /// Delete all completed tasks
  Future<Either<Failure, int>> deleteCompletedTasks();

  /// Delete all tasks
  Future<Either<Failure, int>> deleteAllTasks();
}
