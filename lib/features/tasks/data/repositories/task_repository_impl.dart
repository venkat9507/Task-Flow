import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';

/// Implementation of TaskRepository
@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    try {
      final models = await localDataSource.getAllTasks();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity?>> getTaskById(String id) async {
    try {
      final model = await localDataSource.getTaskById(id);
      return Right(model?.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByCategory(
    String categoryId,
  ) async {
    try {
      final models = await localDataSource.getTasksByCategory(categoryId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByPriority(
    int priority,
  ) async {
    try {
      final models = await localDataSource.getTasksByPriority(priority);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getCompletedTasks() async {
    try {
      final models = await localDataSource.getCompletedTasks();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getPendingTasks() async {
    try {
      final models = await localDataSource.getPendingTasks();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getOverdueTasks() async {
    try {
      final models = await localDataSource.getOverdueTasks();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksDueToday() async {
    try {
      final models = await localDataSource.getTasksDueToday();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> searchTasks(String query) async {
    try {
      final models = await localDataSource.searchTasks(query);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final createdModel = await localDataSource.createTask(model);
      return Right(createdModel.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final updatedModel = await localDataSource.updateTask(model);
      return Right(updatedModel.toEntity());
    } on NotFoundException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      final result = await localDataSource.deleteTask(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> toggleTaskCompletion(String id) async {
    try {
      final toggledModel = await localDataSource.toggleTaskCompletion(id);
      return Right(toggledModel.toEntity());
    } on NotFoundException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteCompletedTasks() async {
    try {
      final count = await localDataSource.deleteCompletedTasks();
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteAllTasks() async {
    try {
      final count = await localDataSource.deleteAllTasks();
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
