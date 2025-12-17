import '../../repositories/preferences_repository.dart';

class DeletePrefKey {
  final PreferencesRepository repository;

  DeletePrefKey(this.repository);

  Future<void> call(String key) {
    return repository.delete(key);
  }
}




