import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/category_repository.dart';

@lazySingleton
class DeleteAllCategories implements UseCase<int, NoParams> {
  final CategoryRepository _repository;

  DeleteAllCategories(this._repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repository.deleteAllCategories();
  }
}
