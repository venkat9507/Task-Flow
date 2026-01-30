import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/task_entity.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Task model - data layer representation with JSON serialization
@freezed
sealed class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @Default(0) int priority,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'due_date') String? dueDate,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  /// Convert from entity to model
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      priority: entity.priority,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      dueDate: entity.dueDate?.toIso8601String(),
    );
  }

  /// Convert to entity
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      priority: priority,
      categoryId: categoryId,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      dueDate: dueDate != null ? DateTime.parse(dueDate!) : null,
    );
  }

  /// Convert to map for SQLite (using snake_case keys)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
      'priority': priority,
      'category_id': categoryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'due_date': dueDate,
    };
  }

  /// Create from SQLite map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: (map['is_completed'] as int) == 1,
      priority: map['priority'] as int? ?? 0,
      categoryId: map['category_id'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      dueDate: map['due_date'] as String?,
    );
  }
}
