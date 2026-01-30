// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_local_data_source.dart'
    as _i852;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i52;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/categories/data/datasources/category_local_data_source.dart'
    as _i390;
import '../../features/categories/data/repositories/category_repository_impl.dart'
    as _i894;
import '../../features/categories/domain/repositories/category_repository.dart'
    as _i266;
import '../../features/categories/domain/usecases/create_category.dart'
    as _i448;
import '../../features/categories/domain/usecases/delete_all_categories.dart'
    as _i790;
import '../../features/categories/domain/usecases/delete_category.dart'
    as _i660;
import '../../features/categories/domain/usecases/get_all_categories.dart'
    as _i1032;
import '../../features/categories/domain/usecases/get_category_by_id.dart'
    as _i777;
import '../../features/categories/domain/usecases/seed_default_categories.dart'
    as _i562;
import '../../features/categories/domain/usecases/update_category.dart'
    as _i524;
import '../../features/tasks/data/datasources/task_local_data_source.dart'
    as _i505;
import '../../features/tasks/data/repositories/task_repository_impl.dart'
    as _i20;
import '../../features/tasks/domain/repositories/task_repository.dart' as _i148;
import '../../features/tasks/domain/usecases/create_task.dart' as _i602;
import '../../features/tasks/domain/usecases/delete_all_tasks.dart' as _i802;
import '../../features/tasks/domain/usecases/delete_completed_tasks.dart'
    as _i17;
import '../../features/tasks/domain/usecases/delete_task.dart' as _i840;
import '../../features/tasks/domain/usecases/get_all_tasks.dart' as _i953;
import '../../features/tasks/domain/usecases/get_completed_tasks.dart' as _i684;
import '../../features/tasks/domain/usecases/get_pending_tasks.dart' as _i162;
import '../../features/tasks/domain/usecases/get_task_by_id.dart' as _i482;
import '../../features/tasks/domain/usecases/get_tasks_by_category.dart'
    as _i48;
import '../../features/tasks/domain/usecases/get_tasks_by_priority.dart'
    as _i424;
import '../../features/tasks/domain/usecases/search_tasks.dart' as _i338;
import '../../features/tasks/domain/usecases/toggle_task_completion.dart'
    as _i136;
import '../../features/tasks/domain/usecases/update_task.dart' as _i739;
import '../database/database_helper.dart' as _i64;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i390.CategoryLocalDataSource>(
      () => _i390.CategoryLocalDataSourceImpl(gh<_i64.DatabaseHelper>()),
    );
    gh.lazySingleton<_i852.AuthLocalDataSource>(
      () => _i852.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i505.TaskLocalDataSource>(
      () => _i505.TaskLocalDataSourceImpl(gh<_i64.DatabaseHelper>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i852.AuthLocalDataSource>()),
    );
    gh.lazySingleton<_i266.CategoryRepository>(
      () => _i894.CategoryRepositoryImpl(gh<_i390.CategoryLocalDataSource>()),
    );
    gh.lazySingleton<_i448.CreateCategory>(
      () => _i448.CreateCategory(gh<_i266.CategoryRepository>()),
    );
    gh.lazySingleton<_i660.DeleteCategory>(
      () => _i660.DeleteCategory(gh<_i266.CategoryRepository>()),
    );
    gh.lazySingleton<_i1032.GetAllCategories>(
      () => _i1032.GetAllCategories(gh<_i266.CategoryRepository>()),
    );
    gh.lazySingleton<_i777.GetCategoryById>(
      () => _i777.GetCategoryById(gh<_i266.CategoryRepository>()),
    );
    gh.lazySingleton<_i524.UpdateCategory>(
      () => _i524.UpdateCategory(gh<_i266.CategoryRepository>()),
    );
    gh.lazySingleton<_i148.TaskRepository>(
      () => _i20.TaskRepositoryImpl(gh<_i505.TaskLocalDataSource>()),
    );
    gh.lazySingleton<_i790.DeleteAllCategories>(
      () => _i790.DeleteAllCategories(gh<_i266.CategoryRepository>()),
    );
    gh.lazySingleton<_i562.SeedDefaultCategories>(
      () => _i562.SeedDefaultCategories(gh<_i266.CategoryRepository>()),
    );
    gh.lazySingleton<_i602.CreateTask>(
      () => _i602.CreateTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i840.DeleteTask>(
      () => _i840.DeleteTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i953.GetAllTasks>(
      () => _i953.GetAllTasks(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i684.GetCompletedTasks>(
      () => _i684.GetCompletedTasks(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i162.GetPendingTasks>(
      () => _i162.GetPendingTasks(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i48.GetTasksByCategory>(
      () => _i48.GetTasksByCategory(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i424.GetTasksByPriority>(
      () => _i424.GetTasksByPriority(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i482.GetTaskById>(
      () => _i482.GetTaskById(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i338.SearchTasks>(
      () => _i338.SearchTasks(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i136.ToggleTaskCompletion>(
      () => _i136.ToggleTaskCompletion(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i739.UpdateTask>(
      () => _i739.UpdateTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i52.CheckAuthStatus>(
      () => _i52.CheckAuthStatus(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i188.Login>(
      () => _i188.Login(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i48.Logout>(
      () => _i48.Logout(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i802.DeleteAllTasks>(
      () => _i802.DeleteAllTasks(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i17.DeleteCompletedTasks>(
      () => _i17.DeleteCompletedTasks(gh<_i148.TaskRepository>()),
    );
    return this;
  }
}
