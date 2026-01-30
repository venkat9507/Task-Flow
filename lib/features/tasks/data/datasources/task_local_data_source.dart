import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/task_model.dart';

/// Task local data source interface
abstract class TaskLocalDataSource {
  /// Get all tasks
  Future<List<TaskModel>> getAllTasks();

  /// Get task by ID
  Future<TaskModel?> getTaskById(String id);

  /// Get tasks by category
  Future<List<TaskModel>> getTasksByCategory(String categoryId);

  /// Get tasks by priority
  Future<List<TaskModel>> getTasksByPriority(int priority);

  /// Get completed tasks
  Future<List<TaskModel>> getCompletedTasks();

  /// Get pending tasks
  Future<List<TaskModel>> getPendingTasks();

  /// Get overdue tasks
  Future<List<TaskModel>> getOverdueTasks();

  /// Get tasks due today
  Future<List<TaskModel>> getTasksDueToday();

  /// Search tasks by title or description
  Future<List<TaskModel>> searchTasks(String query);

  /// Create a new task
  Future<TaskModel> createTask(TaskModel task);

  /// Update a task
  Future<TaskModel> updateTask(TaskModel task);

  /// Delete a task
  Future<bool> deleteTask(String id);

  /// Toggle task completion
  Future<TaskModel> toggleTaskCompletion(String id);

  /// Delete all completed tasks
  Future<int> deleteCompletedTasks();

  /// Delete all tasks
  Future<int> deleteAllTasks();
}

/// Task local data source implementation
@LazySingleton(as: TaskLocalDataSource)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper _databaseHelper;

  TaskLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tasksTable,
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get all tasks: $e');
    }
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tasksTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return TaskModel.fromMap(maps.first);
    } catch (e) {
      throw DatabaseException(message: 'Failed to get task by id: $e');
    }
  }

  @override
  Future<List<TaskModel>> getTasksByCategory(String categoryId) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tasksTable,
        where: 'category_id = ?',
        whereArgs: [categoryId],
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get tasks by category: $e');
    }
  }

  @override
  Future<List<TaskModel>> getTasksByPriority(int priority) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tasksTable,
        where: 'priority = ?',
        whereArgs: [priority],
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get tasks by priority: $e');
    }
  }

  @override
  Future<List<TaskModel>> getCompletedTasks() async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tasksTable,
        where: 'is_completed = ?',
        whereArgs: [1],
        orderBy: 'updated_at DESC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get completed tasks: $e');
    }
  }

  @override
  Future<List<TaskModel>> getPendingTasks() async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.tasksTable,
        where: 'is_completed = ?',
        whereArgs: [0],
        orderBy: 'priority DESC, due_date ASC, created_at DESC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get pending tasks: $e');
    }
  }

  @override
  Future<List<TaskModel>> getOverdueTasks() async {
    try {
      final db = await _databaseHelper.database;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final maps = await db.query(
        AppConstants.tasksTable,
        where: 'is_completed = ? AND due_date IS NOT NULL AND due_date < ?',
        whereArgs: [0, today],
        orderBy: 'due_date ASC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get overdue tasks: $e');
    }
  }

  @override
  Future<List<TaskModel>> getTasksDueToday() async {
    try {
      final db = await _databaseHelper.database;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final maps = await db.query(
        AppConstants.tasksTable,
        where: 'due_date LIKE ?',
        whereArgs: ['$today%'],
        orderBy: 'priority DESC, created_at DESC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get tasks due today: $e');
    }
  }

  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      final db = await _databaseHelper.database;
      final searchQuery = '%$query%';
      final maps = await db.query(
        AppConstants.tasksTable,
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: [searchQuery, searchQuery],
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to search tasks: $e');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert(AppConstants.tasksTable, task.toMap());
      return task;
    } catch (e) {
      throw DatabaseException(message: 'Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        AppConstants.tasksTable,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      if (rowsAffected == 0) {
        throw const NotFoundException(message: 'Task not found');
      }
      return task;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw DatabaseException(message: 'Failed to update task: $e');
    }
  }

  @override
  Future<bool> deleteTask(String id) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.delete(
        AppConstants.tasksTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      return rowsAffected > 0;
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete task: $e');
    }
  }

  @override
  Future<TaskModel> toggleTaskCompletion(String id) async {
    try {
      final task = await getTaskById(id);
      if (task == null) {
        throw const NotFoundException(message: 'Task not found');
      }

      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now().toIso8601String(),
      );

      return await updateTask(updatedTask);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw DatabaseException(message: 'Failed to toggle task completion: $e');
    }
  }

  @override
  Future<int> deleteCompletedTasks() async {
    try {
      final db = await _databaseHelper.database;
      return await db.delete(
        AppConstants.tasksTable,
        where: 'is_completed = ?',
        whereArgs: [1],
      );
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete completed tasks: $e');
    }
  }

  @override
  Future<int> deleteAllTasks() async {
    try {
      final db = await _databaseHelper.database;
      return await db.delete(AppConstants.tasksTable);
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete all tasks: $e');
    }
  }
}
