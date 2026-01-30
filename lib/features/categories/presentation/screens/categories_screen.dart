import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/category_entity.dart';
import '../providers/category_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/add_category_dialog.dart';

/// Categories screen
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryListProvider.notifier).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryListProvider);
    final categories = categoryState.categories;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showAddCategoryDialog(context),
            tooltip: 'Add Category',
          ),
        ],
      ),
      body: categoryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryState.error != null
          ? _buildErrorState(context, categoryState.error!)
          : categories.isEmpty
          ? _buildEmptyState(context)
          : _buildCategoryList(context, categories),
      floatingActionButton:
          FloatingActionButton.extended(
                onPressed: () => _showAddCategoryDialog(context),
                icon: const Icon(Iconsax.add),
                label: const Text('Add Category'),
              )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideY(begin: 1, end: 0, curve: Curves.easeOutBack),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    List<CategoryEntity> categories,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
              category: category,
              onTap: () => _showEditCategoryDialog(context, category),
              onDelete: () => _deleteCategory(category),
            )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: 50 * index),
              duration: 300.ms,
            )
            .slideX(
              begin: 0.1,
              end: 0,
              delay: Duration(milliseconds: 50 * index),
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.category,
                    size: 56,
                    color: colorScheme.primary,
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 24),
            Text(
                  'No categories yet',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 8),
            Text(
                  'Create categories to organize your tasks',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 32),
            FilledButton.icon(
                  onPressed: () => _showAddCategoryDialog(context),
                  icon: const Icon(Iconsax.add),
                  label: const Text('Add Category'),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  ref.read(categoryListProvider.notifier).loadCategories(),
              icon: const Icon(Iconsax.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(
        onSave: (name, color, icon) async {
          final success = await ref
              .read(categoryListProvider.notifier)
              .createCategory(name: name, color: color, icon: icon);
          return success;
        },
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryEntity category) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(
        category: category,
        onSave: (name, color, icon) async {
          final success = await ref
              .read(categoryListProvider.notifier)
              .updateCategory(category, name: name, color: color, icon: icon);
          return success;
        },
      ),
    );
  }

  Future<void> _deleteCategory(CategoryEntity category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category.name}"?\n\n'
          'Tasks in this category will not be deleted, but will have no category.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(categoryListProvider.notifier).deleteCategory(category.id);
    }
  }
}
