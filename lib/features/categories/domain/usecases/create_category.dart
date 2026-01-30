import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Use case to create a new category
@lazySingleton
class CreateCategory implements UseCase<CategoryEntity, CreateCategoryParams> {
  final CategoryRepository repository;
  final Uuid _uuid = const Uuid();

  CreateCategory(this.repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(CreateCategoryParams params) {
    final category = CategoryEntity(
      id: _uuid.v4(),
      name: params.name.trim(),
      color: params.color,
      icon: params.icon,
      createdAt: DateTime.now(),
    );

    return repository.createCategory(category);
  }
}

/// Parameters for CreateCategory use case
class CreateCategoryParams extends Equatable {
  final String name;
  final int color;
  final String? icon;

  const CreateCategoryParams({
    required this.name,
    required this.color,
    this.icon,
  });

  @override
  List<Object?> get props => [name, color, icon];
}
