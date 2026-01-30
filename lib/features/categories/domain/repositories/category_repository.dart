import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';

/// Abstract repository contract for Category operations
abstract class CategoryRepository {
  /// Get all categories
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();

  /// Get all categories with task counts
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesWithTaskCounts();

  /// Get category by ID
  Future<Either<Failure, CategoryEntity?>> getCategoryById(String id);

  /// Create a new category
  Future<Either<Failure, CategoryEntity>> createCategory(
    CategoryEntity category,
  );

  /// Update an existing category
  Future<Either<Failure, CategoryEntity>> updateCategory(
    CategoryEntity category,
  );

  /// Delete a category
  Future<Either<Failure, bool>> deleteCategory(String id);

  /// Check if category name exists
  Future<Either<Failure, bool>> categoryNameExists(
    String name, {
    String? excludeId,
  });

  /// Delete all categories
  Future<Either<Failure, int>> deleteAllCategories();

  /// Seed default categories
  Future<Either<Failure, void>> seedDefaultCategories();
}
