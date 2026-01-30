import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Use case to get tasks by priority
@lazySingleton
class GetTasksByPriority
    implements UseCase<List<TaskEntity>, GetTasksByPriorityParams> {
  final TaskRepository repository;

  GetTasksByPriority(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(
    GetTasksByPriorityParams params,
  ) {
    return repository.getTasksByPriority(params.priority);
  }
}

/// Parameters for GetTasksByPriority use case
class GetTasksByPriorityParams extends Equatable {
  final int priority;

  const GetTasksByPriorityParams({required this.priority});

  @override
  List<Object?> get props => [priority];
}
