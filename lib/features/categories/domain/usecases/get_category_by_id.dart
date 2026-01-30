import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Use case to get category by ID
@lazySingleton
class GetCategoryById
    implements UseCase<CategoryEntity?, GetCategoryByIdParams> {
  final CategoryRepository repository;

  GetCategoryById(this.repository);

  @override
  Future<Either<Failure, CategoryEntity?>> call(GetCategoryByIdParams params) {
    return repository.getCategoryById(params.id);
  }
}

/// Parameters for GetCategoryById use case
class GetCategoryByIdParams extends Equatable {
  final String id;

  const GetCategoryByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
