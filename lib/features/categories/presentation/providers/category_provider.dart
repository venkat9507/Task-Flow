import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/delete_all_categories.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_all_categories.dart';
import '../../domain/usecases/seed_default_categories.dart';
import '../../domain/usecases/update_category.dart';

/// Category list state
class CategoryListState {
  final List<CategoryEntity> categories;
  final bool isLoading;
  final String? error;
  final String? selectedCategoryId;

  const CategoryListState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategoryId,
  });

  CategoryListState copyWith({
    List<CategoryEntity>? categories,
    bool? isLoading,
    String? error,
    String? selectedCategoryId,
    bool clearError = false,
    bool clearSelection = false,
  }) {
    return CategoryListState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedCategoryId: clearSelection
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }

  /// Get selected category
  CategoryEntity? get selectedCategory {
    if (selectedCategoryId == null) return null;
    try {
      return categories.firstWhere((c) => c.id == selectedCategoryId);
    } catch (_) {
      return null;
    }
  }

  /// Get total task count across all categories
  int get totalTasks {
    return categories.fold(0, (sum, cat) => sum + cat.taskCount);
  }
}

/// Category list notifier
class CategoryListNotifier extends StateNotifier<CategoryListState> {
  final GetAllCategories _getAllCategories;
  final CreateCategory _createCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;
  final DeleteAllCategories _deleteAllCategories;
  final SeedDefaultCategories _seedDefaultCategories;

  CategoryListNotifier({
    required GetAllCategories getAllCategories,
    required CreateCategory createCategory,
    required UpdateCategory updateCategory,
    required DeleteCategory deleteCategory,
    required DeleteAllCategories deleteAllCategories,
    required SeedDefaultCategories seedDefaultCategories,
  }) : _getAllCategories = getAllCategories,
       _createCategory = createCategory,
       _updateCategory = updateCategory,
       _deleteCategory = deleteCategory,
       _deleteAllCategories = deleteAllCategories,
       _seedDefaultCategories = seedDefaultCategories,
       super(const CategoryListState());

  /// Load all categories with task counts
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getAllCategories();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (categories) =>
          state = state.copyWith(isLoading: false, categories: categories),
    );
  }

  /// Create a new category
  Future<bool> createCategory({
    required String name,
    required int color,
    String? icon,
  }) async {
    final result = await _createCategory(
      CreateCategoryParams(name: name, color: color, icon: icon),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (category) {
        state = state.copyWith(
          categories: [...state.categories, category],
          clearError: true,
        );
        return true;
      },
    );
  }

  /// Update a category
  Future<bool> updateCategory(
    CategoryEntity category, {
    String? name,
    int? color,
    String? icon,
  }) async {
    final result = await _updateCategory(
      UpdateCategoryParams(
        category: category,
        name: name,
        color: color,
        icon: icon,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (updatedCategory) {
        final updatedCategories = state.categories.map((c) {
          return c.id == updatedCategory.id ? updatedCategory : c;
        }).toList();
        state = state.copyWith(categories: updatedCategories, clearError: true);
        return true;
      },
    );
  }

  /// Delete a category
  Future<bool> deleteCategory(String id) async {
    final result = await _deleteCategory(DeleteCategoryParams(id: id));

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (success) {
        if (success) {
          state = state.copyWith(
            categories: state.categories.where((c) => c.id != id).toList(),
            clearError: true,
          );
          // Clear selection if deleted category was selected
          if (state.selectedCategoryId == id) {
            state = state.copyWith(clearSelection: true);
          }
        }
        return success;
      },
    );
  }

  /// Select a category
  void selectCategory(String? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(clearSelection: true);
    } else {
      state = state.copyWith(selectedCategoryId: categoryId);
    }
  }

  /// Delete all categories
  Future<void> deleteAllCategories() async {
    final result = await _deleteAllCategories(NoParams());

    result.fold((failure) => state = state.copyWith(error: failure.message), (
      count,
    ) {
      state = state.copyWith(
        categories: [],
        clearSelection: true,
        clearError: true,
      );
    });
  }

  /// Reset categories to defaults
  Future<void> resetCategories() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final deleteResult = await _deleteAllCategories(NoParams());

    await deleteResult.fold(
      (failure) async =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (_) async {
        final seedResult = await _seedDefaultCategories(NoParams());

        await seedResult.fold(
          (failure) async =>
              state = state.copyWith(isLoading: false, error: failure.message),
          (_) async => await loadCategories(),
        );
      },
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Category list provider
final categoryListProvider =
    StateNotifierProvider<CategoryListNotifier, CategoryListState>((ref) {
      return CategoryListNotifier(
        getAllCategories: getIt<GetAllCategories>(),
        createCategory: getIt<CreateCategory>(),
        updateCategory: getIt<UpdateCategory>(),
        deleteCategory: getIt<DeleteCategory>(),
        deleteAllCategories: getIt<DeleteAllCategories>(),
        seedDefaultCategories: getIt<SeedDefaultCategories>(),
      );
    });

/// All categories provider (derived)
final allCategoriesProvider = Provider<List<CategoryEntity>>((ref) {
  return ref.watch(categoryListProvider).categories;
});

/// Selected category provider
final selectedCategoryProvider = Provider<CategoryEntity?>((ref) {
  return ref.watch(categoryListProvider).selectedCategory;
});

/// Category by ID provider
final categoryByIdProvider = Provider.family<CategoryEntity?, String>((
  ref,
  id,
) {
  final categories = ref.watch(categoryListProvider).categories;
  try {
    return categories.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
});
