import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageDataSource {
  /// Secure storage methods (for sensitive data like API keys, tokens)
  Future<void> saveSecureString(String key, String value);
  Future<String?> getSecureString(String key);
  Future<void> deleteSecureString(String key);
  Future<void> clearSecureStorage();

  /// Shared preferences methods (for non-sensitive data like settings, favorites)
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> delete(String key);
  Future<void> clear();
}

@LazySingleton(as: LocalStorageDataSource)
class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  LocalStorageDataSourceImpl(this._secureStorage, this._sharedPreferences);
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  // Secure Storage Implementation
  @override
  Future<void> saveSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecureString(String key) async {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> deleteSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // Shared Preferences Implementation
  @override
  Future<void> saveString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> saveStringList(String key, List<String> value) async {
    await _sharedPreferences.setStringList(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _sharedPreferences.getStringList(key);
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _sharedPreferences.getBool(key);
  }

  @override
  Future<void> delete(String key) async {
    await _sharedPreferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}

// Register external dependencies
@module
abstract class LocalStorageModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
