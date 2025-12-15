import '../../repositories/secure_storage_repository.dart';

class ReadSecureValue {
  final SecureStorageRepository repository;

  ReadSecureValue(this.repository);

  Future<String?> call(String key) {
    return repository.readString(key);
  }
}

