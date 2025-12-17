import '../../repositories/secure_storage_repository.dart';

class DeleteSecureValue {
  final SecureStorageRepository repository;

  DeleteSecureValue(this.repository);

  Future<void> call(String key) {
    return repository.delete(key);
  }
}




