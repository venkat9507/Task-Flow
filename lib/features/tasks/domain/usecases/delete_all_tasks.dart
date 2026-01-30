import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/task_repository.dart';

@lazySingleton
class DeleteAllTasks implements UseCase<int, NoParams> {
  final TaskRepository _repository;

  DeleteAllTasks(this._repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repository.deleteAllTasks();
  }
}
