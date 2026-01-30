import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      // Mock validation
      if (email == 'test@test.com' && password == '123456') {
        const user = UserEntity(email: 'test@test.com', name: 'Test User');
        await _localDataSource.saveUserSession(email);
        return const Right(user);
      } else {
        return const Left(AuthFailure(message: 'Invalid credentials'));
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearUserSession();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> checkAuthStatus() async {
    try {
      final email = await _localDataSource.getUserSession();
      if (email != null) {
        return Right(UserEntity(email: email, name: 'Test User'));
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
