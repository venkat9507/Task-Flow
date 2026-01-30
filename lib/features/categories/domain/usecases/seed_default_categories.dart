import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/category_repository.dart';

@lazySingleton
class SeedDefaultCategories implements UseCase<void, NoParams> {
  final CategoryRepository _repository;

  SeedDefaultCategories(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.seedDefaultCategories();
  }
}
