import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';

/// Task entity - represents a task in the domain layer
@freezed
sealed class TaskEntity with _$TaskEntity {
  const TaskEntity._();

  const factory TaskEntity({
    required String id,
    required String title,
    String? description,
    @Default(false) bool isCompleted,
    @Default(0) int priority, // 0=none, 1=low, 2=medium, 3=high
    String? categoryId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? dueDate,
  }) = _TaskEntity;

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDueDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return taskDueDate.isBefore(today);
  }

  /// Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  /// Check if task is due tomorrow
  bool get isDueTomorrow {
    if (dueDate == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dueDate!.year == tomorrow.year &&
        dueDate!.month == tomorrow.month &&
        dueDate!.day == tomorrow.day;
  }

  /// Get priority label
  String get priorityLabel {
    switch (priority) {
      case 3:
        return 'High';
      case 2:
        return 'Medium';
      case 1:
        return 'Low';
      default:
        return 'None';
    }
  }

  /// Check if has high priority
  bool get isHighPriority => priority == 3;

  /// Check if has any priority set
  bool get hasPriority => priority > 0;
}
