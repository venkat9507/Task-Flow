import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Use case to update an existing category
@lazySingleton
class UpdateCategory implements UseCase<CategoryEntity, UpdateCategoryParams> {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(UpdateCategoryParams params) {
    final updatedCategory = params.category.copyWith(
      name: params.name?.trim() ?? params.category.name,
      color: params.color ?? params.category.color,
      icon: params.icon ?? params.category.icon,
    );

    return repository.updateCategory(updatedCategory);
  }
}

/// Parameters for UpdateCategory use case
class UpdateCategoryParams extends Equatable {
  final CategoryEntity category;
  final String? name;
  final int? color;
  final String? icon;

  const UpdateCategoryParams({
    required this.category,
    this.name,
    this.color,
    this.icon,
  });

  @override
  List<Object?> get props => [category, name, color, icon];
}
