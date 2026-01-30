import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/category_model.dart';

/// Category local data source interface
abstract class CategoryLocalDataSource {
  /// Get all categories
  Future<List<CategoryModel>> getAllCategories();

  /// Get category by ID
  Future<CategoryModel?> getCategoryById(String id);

  /// Create a new category
  Future<CategoryModel> createCategory(CategoryModel category);

  /// Update a category
  Future<CategoryModel> updateCategory(CategoryModel category);

  /// Delete a category
  Future<bool> deleteCategory(String id);

  /// Get category with task count
  Future<Map<String, int>> getCategoryTaskCounts();

  /// Check if category name exists
  Future<bool> categoryNameExists(String name, {String? excludeId});

  /// Delete all categories (except defaults)
  Future<int> deleteAllCategories();

  /// Seed default categories
  Future<void> seedDefaultCategories();
}

/// Category local data source implementation
@LazySingleton(as: CategoryLocalDataSource)
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper _databaseHelper;

  CategoryLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.categoriesTable,
        orderBy: 'created_at ASC',
      );
      return maps.map((map) => CategoryModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get all categories: $e');
    }
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        AppConstants.categoriesTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return CategoryModel.fromMap(maps.first);
    } catch (e) {
      throw DatabaseException(message: 'Failed to get category by id: $e');
    }
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      // Check if name already exists
      if (await categoryNameExists(category.name)) {
        throw const ValidationException(
          message: 'A category with this name already exists',
        );
      }

      final db = await _databaseHelper.database;
      await db.insert(AppConstants.categoriesTable, category.toMap());
      return category;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException(message: 'Failed to create category: $e');
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      // Check if name already exists (excluding current category)
      if (await categoryNameExists(category.name, excludeId: category.id)) {
        throw const ValidationException(
          message: 'A category with this name already exists',
        );
      }

      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        AppConstants.categoriesTable,
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
      if (rowsAffected == 0) {
        throw const NotFoundException(message: 'Category not found');
      }
      return category;
    } catch (e) {
      if (e is ValidationException || e is NotFoundException) rethrow;
      throw DatabaseException(message: 'Failed to update category: $e');
    }
  }

  @override
  Future<bool> deleteCategory(String id) async {
    try {
      final db = await _databaseHelper.database;

      // First, set category_id to null for all tasks with this category
      await db.update(
        AppConstants.tasksTable,
        {'category_id': null},
        where: 'category_id = ?',
        whereArgs: [id],
      );

      // Then delete the category
      final rowsAffected = await db.delete(
        AppConstants.categoriesTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      return rowsAffected > 0;
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete category: $e');
    }
  }

  @override
  Future<Map<String, int>> getCategoryTaskCounts() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery('''
        SELECT category_id, COUNT(*) as count 
        FROM ${AppConstants.tasksTable} 
        WHERE category_id IS NOT NULL 
        GROUP BY category_id
      ''');

      final counts = <String, int>{};
      for (final row in result) {
        final categoryId = row['category_id'] as String?;
        final count = row['count'] as int;
        if (categoryId != null) {
          counts[categoryId] = count;
        }
      }
      return counts;
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to get category task counts: $e',
      );
    }
  }

  @override
  Future<bool> categoryNameExists(String name, {String? excludeId}) async {
    try {
      final db = await _databaseHelper.database;
      final normalizedName = name.trim().toLowerCase();

      String where = 'LOWER(TRIM(name)) = ?';
      List<dynamic> whereArgs = [normalizedName];

      if (excludeId != null) {
        where += ' AND id != ?';
        whereArgs.add(excludeId);
      }

      final result = await db.query(
        AppConstants.categoriesTable,
        where: where,
        whereArgs: whereArgs,
      );

      return result.isNotEmpty;
    } catch (e) {
      throw DatabaseException(message: 'Failed to check category name: $e');
    }
  }

  @override
  Future<int> deleteAllCategories() async {
    try {
      final db = await _databaseHelper.database;

      // Set all task category_ids to null
      await db.update(AppConstants.tasksTable, {'category_id': null});

      // Delete all categories
      return await db.delete(AppConstants.categoriesTable);
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete all categories: $e');
    }
  }

  @override
  Future<void> seedDefaultCategories() async {
    try {
      final db = await _databaseHelper.database;
      await _databaseHelper.insertDefaultCategories(db);
    } catch (e) {
      throw DatabaseException(message: 'Failed to seed default categories: $e');
    }
  }
}
