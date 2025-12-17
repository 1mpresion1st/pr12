import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final SharedPreferences _prefs;

  PreferencesRepositoryImpl(this._prefs);

  @override
  Future<String?> readString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> writeString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      // Игнорируем ошибки при записи
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      // Игнорируем ошибки при удалении
    }
  }
}




