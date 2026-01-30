import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Use case to search tasks by query
@lazySingleton
class SearchTasks implements UseCase<List<TaskEntity>, SearchTasksParams> {
  final TaskRepository repository;

  SearchTasks(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(SearchTasksParams params) {
    if (params.query.trim().isEmpty) {
      return repository.getAllTasks();
    }
    return repository.searchTasks(params.query.trim());
  }
}

/// Parameters for SearchTasks use case
class SearchTasksParams extends Equatable {
  final String query;

  const SearchTasksParams({required this.query});

  @override
  List<Object?> get props => [query];
}
