import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';

/// Category entity - represents a category in the domain layer
@freezed
sealed class CategoryEntity with _$CategoryEntity {
  const CategoryEntity._();

  const factory CategoryEntity({
    required String id,
    required String name,
    required int color, // Color value as int
    String? icon, // Icon name/code
    required DateTime createdAt,
    @Default(0) int taskCount, // Number of tasks in this category
  }) = _CategoryEntity;

  /// Check if category has tasks
  bool get hasTasks => taskCount > 0;
}
