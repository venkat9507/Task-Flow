import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Use case to get all tasks
@lazySingleton
class GetAllTasks implements UseCaseNoParams<List<TaskEntity>> {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call() {
    return repository.getAllTasks();
  }
}
