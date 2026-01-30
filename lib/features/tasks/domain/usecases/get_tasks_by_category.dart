import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Use case to get tasks by category
@lazySingleton
class GetTasksByCategory
    implements UseCase<List<TaskEntity>, GetTasksByCategoryParams> {
  final TaskRepository repository;

  GetTasksByCategory(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(
    GetTasksByCategoryParams params,
  ) {
    return repository.getTasksByCategory(params.categoryId);
  }
}

/// Parameters for GetTasksByCategory use case
class GetTasksByCategoryParams extends Equatable {
  final String categoryId;

  const GetTasksByCategoryParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
