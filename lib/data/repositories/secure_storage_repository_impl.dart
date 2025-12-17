import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/secure_storage_repository.dart';

class SecureStorageRepositoryImpl implements SecureStorageRepository {
  final FlutterSecureStorage _storage;

  SecureStorageRepositoryImpl(this._storage);

  @override
  Future<String?> readString(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      // На Web flutter_secure_storage может не работать корректно
      // В этом случае возвращаем null, чтобы не ломать приложение
      if (kIsWeb) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> writeString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      // На Web flutter_secure_storage может не работать корректно
      // В этом случае просто игнорируем ошибку, чтобы не ломать приложение
      if (kIsWeb) {
        return;
      }
      rethrow;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      // На Web flutter_secure_storage может не работать корректно
      // В этом случае просто игнорируем ошибку, чтобы не ломать приложение
      if (kIsWeb) {
        return;
      }
      rethrow;
    }
  }
}




