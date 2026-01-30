import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserSession(String email);
  Future<String?> getUserSession();
  Future<void> clearUserSession();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;
  static const String _userEmailKey = 'user_email';

  AuthLocalDataSourceImpl(this._storage);

  @override
  Future<void> saveUserSession(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  @override
  Future<String?> getUserSession() async {
    return await _storage.read(key: _userEmailKey);
  }

  @override
  Future<void> clearUserSession() async {
    await _storage.delete(key: _userEmailKey);
  }
}
