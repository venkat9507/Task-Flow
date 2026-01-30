import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Use case to get all categories with task counts
@lazySingleton
class GetAllCategories implements UseCaseNoParams<List<CategoryEntity>> {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategoriesWithTaskCounts();
  }
}
