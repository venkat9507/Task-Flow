import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/category_repository.dart';

/// Use case to delete a category
@lazySingleton
class DeleteCategory implements UseCase<bool, DeleteCategoryParams> {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteCategoryParams params) {
    return repository.deleteCategory(params.id);
  }
}

/// Parameters for DeleteCategory use case
class DeleteCategoryParams extends Equatable {
  final String id;

  const DeleteCategoryParams({required this.id});

  @override
  List<Object?> get props => [id];
}
