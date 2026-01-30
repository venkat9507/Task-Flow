import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_provider.dart';

/// Add/Edit Task screen
class AddEditTaskScreen extends ConsumerStatefulWidget {
  final String? taskId;

  const AddEditTaskScreen({super.key, this.taskId});

  bool get isEditing => taskId != null;

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _priority = 0;
  String? _categoryId;
  DateTime? _dueDate;
  bool _isLoading = false;

  TaskEntity? _existingTask;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadExistingTask();
    }
    // Load categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryListProvider.notifier).loadCategories();
    });
  }

  void _loadExistingTask() {
    final tasks = ref.read(taskListProvider).tasks;
    try {
      _existingTask = tasks.firstWhere((t) => t.id == widget.taskId);
      _titleController.text = _existingTask!.title;
      _descriptionController.text = _existingTask!.description ?? '';
      _priority = _existingTask!.priority;
      _categoryId = _existingTask!.categoryId;
      _dueDate = _existingTask!.dueDate;
    } catch (_) {
      // Task not found
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(allCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.isEditing ? 'Edit Task' : 'New Task'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveTask,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'What needs to be done?',
                prefixIcon: Icon(Iconsax.edit_2),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
              autofocus: !widget.isEditing,
            ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Add more details...',
                    prefixIcon: Icon(Iconsax.document_text),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideX(begin: 0.1, end: 0),
            const SizedBox(height: 24),

            // Priority selector
            Text(
              'Priority',
              style: theme.textTheme.titleMedium,
            ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
            const SizedBox(height: 12),
            _buildPrioritySelector(theme)
                .animate()
                .fadeIn(delay: 250.ms, duration: 300.ms)
                .slideX(begin: 0.1, end: 0),
            const SizedBox(height: 24),

            // Category selector
            Card(
                  child: ListTile(
                    leading: const Icon(Iconsax.category),
                    title: const Text('Category'),
                    subtitle: Text(
                      _categoryId != null
                          ? categories
                                    .where((c) => c.id == _categoryId)
                                    .firstOrNull
                                    ?.name ??
                                'Select category'
                          : 'None',
                    ),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () => _showCategoryPicker(context, categories),
                  ),
                )
                .animate()
                .fadeIn(delay: 300.ms, duration: 300.ms)
                .slideX(begin: 0.1, end: 0),
            const SizedBox(height: 8),

            // Due date picker
            Card(
                  child: ListTile(
                    leading: Icon(
                      Iconsax.calendar,
                      color:
                          _dueDate != null &&
                              _dueDate!.isBefore(DateTime.now()) &&
                              !_isToday(_dueDate!)
                          ? AppColors.error
                          : null,
                    ),
                    title: const Text('Due Date'),
                    subtitle: Text(
                      _dueDate != null ? _formatDate(_dueDate!) : 'Not set',
                      style: TextStyle(
                        color:
                            _dueDate != null &&
                                _dueDate!.isBefore(DateTime.now()) &&
                                !_isToday(_dueDate!)
                            ? AppColors.error
                            : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_dueDate != null)
                          IconButton(
                            icon: const Icon(Iconsax.close_circle),
                            onPressed: () => setState(() => _dueDate = null),
                          ),
                        const Icon(Iconsax.arrow_right_3),
                      ],
                    ),
                    onTap: () => _showDatePicker(context),
                  ),
                )
                .animate()
                .fadeIn(delay: 350.ms, duration: 300.ms)
                .slideX(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector(ThemeData theme) {
    final priorities = [
      (0, 'None', Colors.grey),
      (1, 'Low', AppColors.priorityLow),
      (2, 'Medium', AppColors.priorityMedium),
      (3, 'High', AppColors.priorityHigh),
    ];

    return Row(
      children: priorities.map((p) {
        final isSelected = _priority == p.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: p.$1 < 3 ? 8 : 0),
            child: ChoiceChip(
              label: Text(p.$2),
              selected: isSelected,
              onSelected: (_) => setState(() => _priority = p.$1),
              avatar: p.$1 > 0
                  ? Icon(
                      Iconsax.flag5,
                      size: 16,
                      color: isSelected ? Colors.white : p.$3,
                    )
                  : null,
              selectedColor: p.$3,
              labelStyle: TextStyle(color: isSelected ? Colors.white : null),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showCategoryPicker(BuildContext context, List<dynamic> categories) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Iconsax.close_circle),
              title: const Text('None'),
              selected: _categoryId == null,
              onTap: () {
                setState(() => _categoryId = null);
                Navigator.pop(context);
              },
            ),
            ...categories.map(
              (category) => ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Color(category.color),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(category.name),
                selected: _categoryId == category.id,
                onTap: () {
                  setState(() => _categoryId = category.id);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool success;
    if (widget.isEditing && _existingTask != null) {
      success = await ref
          .read(taskListProvider.notifier)
          .updateTask(
            _existingTask!,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            priority: _priority,
            categoryId: _categoryId,
            dueDate: _dueDate,
          );
    } else {
      success = await ref
          .read(taskListProvider.notifier)
          .createTask(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            priority: _priority,
            categoryId: _categoryId,
            dueDate: _dueDate,
          );
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.pop();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
