import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Use case to create a new task
@lazySingleton
class CreateTask implements UseCase<TaskEntity, CreateTaskParams> {
  final TaskRepository repository;
  final Uuid _uuid = const Uuid();

  CreateTask(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(CreateTaskParams params) {
    final now = DateTime.now();
    final task = TaskEntity(
      id: _uuid.v4(),
      title: params.title.trim(),
      description: params.description?.trim(),
      priority: params.priority,
      categoryId: params.categoryId,
      dueDate: params.dueDate,
      createdAt: now,
      updatedAt: now,
    );

    return repository.createTask(task);
  }
}

/// Parameters for CreateTask use case
class CreateTaskParams extends Equatable {
  final String title;
  final String? description;
  final int priority;
  final String? categoryId;
  final DateTime? dueDate;

  const CreateTaskParams({
    required this.title,
    this.description,
    this.priority = 0,
    this.categoryId,
    this.dueDate,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    priority,
    categoryId,
    dueDate,
  ];
}
