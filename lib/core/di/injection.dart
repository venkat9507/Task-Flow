import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import 'injection.config.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize all dependencies
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // Register external dependencies first
  await _registerExternalDependencies();

  // Initialize generated dependencies
  getIt.init();
}

/// Register external dependencies that can't be auto-generated
Future<void> _registerExternalDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Database Helper
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Flutter Secure Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
}
