import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../models/category_model.dart';

/// Implementation of CategoryRepository
@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final models = await localDataSource.getAllCategories();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>>
  getCategoriesWithTaskCounts() async {
    try {
      final models = await localDataSource.getAllCategories();
      final taskCounts = await localDataSource.getCategoryTaskCounts();

      final entities = models.map((model) {
        final count = taskCounts[model.id] ?? 0;
        return model.toEntity(taskCount: count);
      }).toList();

      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity?>> getCategoryById(String id) async {
    try {
      final model = await localDataSource.getCategoryById(id);
      return Right(model?.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory(
    CategoryEntity category,
  ) async {
    try {
      final model = CategoryModel.fromEntity(category);
      final createdModel = await localDataSource.createCategory(model);
      return Right(createdModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, code: e.code));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(
    CategoryEntity category,
  ) async {
    try {
      final model = CategoryModel.fromEntity(category);
      final updatedModel = await localDataSource.updateCategory(model);
      return Right(updatedModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, code: e.code));
    } on NotFoundException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String id) async {
    try {
      final result = await localDataSource.deleteCategory(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> categoryNameExists(
    String name, {
    String? excludeId,
  }) async {
    try {
      final exists = await localDataSource.categoryNameExists(
        name,
        excludeId: excludeId,
      );
      return Right(exists);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteAllCategories() async {
    try {
      final count = await localDataSource.deleteAllCategories();
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> seedDefaultCategories() async {
    try {
      await localDataSource.seedDefaultCategories();
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
