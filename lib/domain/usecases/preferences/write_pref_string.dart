import '../../repositories/preferences_repository.dart';

class WritePrefString {
  final PreferencesRepository repository;

  WritePrefString(this.repository);

  Future<void> call(String key, String value) {
    return repository.writeString(key, value);
  }
}

