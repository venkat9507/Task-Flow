import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Use case to get task by ID
@lazySingleton
class GetTaskById implements UseCase<TaskEntity?, GetTaskByIdParams> {
  final TaskRepository repository;

  GetTaskById(this.repository);

  @override
  Future<Either<Failure, TaskEntity?>> call(GetTaskByIdParams params) {
    return repository.getTaskById(params.id);
  }
}

/// Parameters for GetTaskById use case
class GetTaskByIdParams extends Equatable {
  final String id;

  const GetTaskByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
