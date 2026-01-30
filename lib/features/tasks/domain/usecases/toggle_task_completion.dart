import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Use case to toggle task completion status
@lazySingleton
class ToggleTaskCompletion
    implements UseCase<TaskEntity, ToggleTaskCompletionParams> {
  final TaskRepository repository;

  ToggleTaskCompletion(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(ToggleTaskCompletionParams params) {
    return repository.toggleTaskCompletion(params.id);
  }
}

/// Parameters for ToggleTaskCompletion use case
class ToggleTaskCompletionParams extends Equatable {
  final String id;

  const ToggleTaskCompletionParams({required this.id});

  @override
  List<Object?> get props => [id];
}
