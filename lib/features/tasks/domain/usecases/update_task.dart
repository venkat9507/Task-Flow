import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Use case to update an existing task
@lazySingleton
class UpdateTask implements UseCase<TaskEntity, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(UpdateTaskParams params) {
    final updatedTask = params.task.copyWith(
      title: params.title?.trim() ?? params.task.title,
      description: params.description?.trim() ?? params.task.description,
      priority: params.priority ?? params.task.priority,
      categoryId: params.categoryId ?? params.task.categoryId,
      dueDate: params.dueDate ?? params.task.dueDate,
      updatedAt: DateTime.now(),
    );

    return repository.updateTask(updatedTask);
  }
}

/// Parameters for UpdateTask use case
class UpdateTaskParams extends Equatable {
  final TaskEntity task;
  final String? title;
  final String? description;
  final int? priority;
  final String? categoryId;
  final DateTime? dueDate;
  final bool clearDueDate;
  final bool clearCategory;

  const UpdateTaskParams({
    required this.task,
    this.title,
    this.description,
    this.priority,
    this.categoryId,
    this.dueDate,
    this.clearDueDate = false,
    this.clearCategory = false,
  });

  @override
  List<Object?> get props => [
    task,
    title,
    description,
    priority,
    categoryId,
    dueDate,
    clearDueDate,
    clearCategory,
  ];
}
