import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category_entity.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Category model - data layer representation with JSON serialization
@freezed
sealed class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    required String id,
    required String name,
    required int color,
    String? icon,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Convert from entity to model
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      icon: entity.icon,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  /// Convert to entity
  CategoryEntity toEntity({int taskCount = 0}) {
    return CategoryEntity(
      id: id,
      name: name,
      color: color,
      icon: icon,
      createdAt: DateTime.parse(createdAt),
      taskCount: taskCount,
    );
  }

  /// Convert to map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'created_at': createdAt,
    };
  }

  /// Create from SQLite map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      color: map['color'] as int,
      icon: map['icon'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}
