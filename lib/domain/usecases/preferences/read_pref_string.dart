import '../../repositories/preferences_repository.dart';

class ReadPrefString {
  final PreferencesRepository repository;

  ReadPrefString(this.repository);

  Future<String?> call(String key) {
    return repository.readString(key);
  }
}




