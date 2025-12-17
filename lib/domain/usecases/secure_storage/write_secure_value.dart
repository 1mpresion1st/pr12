import '../../repositories/secure_storage_repository.dart';

class WriteSecureValue {
  final SecureStorageRepository repository;

  WriteSecureValue(this.repository);

  Future<void> call(String key, String value) {
    return repository.writeString(key, value);
  }
}




