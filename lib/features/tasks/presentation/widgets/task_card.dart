import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../domain/entities/task_entity.dart';
import '../../../../core/constants/app_colors.dart';

/// Task card widget with animations
class TaskCard extends ConsumerWidget {
  final TaskEntity task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Iconsax.trash, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                _buildCheckbox(context),
                const SizedBox(width: 12),

                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with priority indicator
                      Row(
                        children: [
                          if (task.hasPriority) ...[
                            _buildPriorityIndicator(),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              task.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      )
                                    : colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Description
                      if (task.description != null &&
                          task.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // Due date & category chips
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (task.dueDate != null) _buildDueDateChip(context),
                          if (task.categoryId != null) ...[
                            const SizedBox(width: 8),
                            _buildCategoryChip(context),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: task.isCompleted ? colorScheme.primary : Colors.transparent,
          border: Border.all(
            color: task.isCompleted ? colorScheme.primary : colorScheme.outline,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: task.isCompleted
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    Color color;
    IconData icon;

    switch (task.priority) {
      case 3:
        color = AppColors.priorityHigh;
        icon = Iconsax.flag5;
        break;
      case 2:
        color = AppColors.priorityMedium;
        icon = Iconsax.flag5;
        break;
      case 1:
        color = AppColors.priorityLow;
        icon = Iconsax.flag5;
        break;
      default:
        color = Colors.grey;
        icon = Iconsax.flag;
    }

    return Icon(icon, size: 16, color: color);
  }

  Widget _buildDueDateChip(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = task.isOverdue;
    final isToday = task.isDueToday;
    final isTomorrow = task.isDueTomorrow;

    String text;
    Color bgColor;
    Color textColor;

    if (task.isCompleted) {
      text = _formatDate(task.dueDate!);
      bgColor = theme.colorScheme.surfaceContainerHighest;
      textColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    } else if (isOverdue) {
      text = 'Overdue';
      bgColor = AppColors.error.withValues(alpha: 0.15);
      textColor = AppColors.error;
    } else if (isToday) {
      text = 'Today';
      bgColor = AppColors.priorityMedium.withValues(alpha: 0.15);
      textColor = AppColors.priorityMedium;
    } else if (isTomorrow) {
      text = 'Tomorrow';
      bgColor = theme.colorScheme.primary.withValues(alpha: 0.15);
      textColor = theme.colorScheme.primary;
    } else {
      text = _formatDate(task.dueDate!);
      bgColor = theme.colorScheme.surfaceContainerHighest;
      textColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.calendar, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: Get category from provider
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.category,
            size: 12,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            'Category',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }
}
