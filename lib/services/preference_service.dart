import 'package:bapa_sitaram/services/encryption_service.dart';
import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  factory PreferenceService() => _instance;
  PreferenceService._internal();
  static final PreferenceService _instance = PreferenceService._internal();
  late final SharedPreferences _box;
  bool isInitialized = false;
  bool isEncryptionEnabled = false;
  Future<void> initPreference() async {
    try {
          _box = await SharedPreferences.getInstance();
          isInitialized = true;
    } catch (e) {
      
      LoggerService().log(message: e);
    }
  }

  void clear() {
    _box.clear();
  }

  bool contains({required String key}) {
    return _box.containsKey(key);
  }

  void setInt({required String key, required int value}) {
    if (isEncryptionEnabled) {
      setString(key: key, value: value.toString());
    } else {
      _box.setInt(key, value);
    }
  }

  int getInt({required String key, int defaultValue = 0}) {
    if (isEncryptionEnabled) {
      try {
        String temp = getString(key: key);
        return int.parse(temp);
      } catch (e) {
        LoggerService().log(message: e);
        return defaultValue;
      }
    } else {
      return _box.getInt(key) ?? defaultValue;
    }
  }

  void setString({required String key, required String value}) {
    try {
      if (isEncryptionEnabled) {
        if (value.isEmpty) {
          _box.setString(key, '');
        } else {
          String encrypted = EncryptionService().encrypt(content: value);
          _box.setString(key, encrypted);
        }
      } else {
        _box.setString(key, value);
      }
    } catch (e) {
      LoggerService().log(message: e);
      // handle encryption error
    }
  }

  String getString({required String key, String defaultValue = ''}) {
    try {
      String value = _box.getString(key)??defaultValue;
      if (isEncryptionEnabled) {
        if (value == defaultValue || value.isEmpty) return value;
        return EncryptionService().decrypt(encryptedContent: value);
      }
      return value;
    } catch (e) {
      LoggerService().log(message: e);
      return defaultValue;
    }
  }

  void setBoolean({required String key, required bool value}) {
    if (isEncryptionEnabled) {
      setString(key: key, value: value.toString());
    } else {
      _box.setBool(key, value);
    }
  }

  bool getBoolean({required String key, bool defaultValue = false}) {
    if (isEncryptionEnabled) {
      String temp = getString(key: key);
      return temp == 'true';
    } else {
      return _box.getBool(key) ?? defaultValue;
    }
  }

  void setDouble({required String key, required double value}) {
    if (isEncryptionEnabled) {
      setString(key: key, value: value.toString());
    } else {
      _box.setDouble(key, value);
    }
  }

  double getDouble({required String key}) {
    if (isEncryptionEnabled) {
      String temp = getString(key: key);
      return double.tryParse(temp) ?? 0.0;
    } else {
      return _box.getDouble(key) ?? 0.0;
    }
  }

  void setStringList({required String key, required List<String> value}) {
    List<String> temp = [];
    if (isEncryptionEnabled) {
      for (var val in value) {
        if (val.isNotEmpty) {
          temp.add(EncryptionService().encrypt(content: val));
        } else {
          temp.add('');
        }
      }
    } else {
      temp = value;
    }
    _box.setStringList(key, temp);
  }

  List<String> getStringList({required String key}) {
    List<String> temp = (_box.getStringList(key) as List?)?.cast<String>() ?? [];
    if (isEncryptionEnabled) {
      for (int i = 0; i < temp.length; i++) {
        if (temp[i].isNotEmpty) {
          temp[i] = EncryptionService().decrypt(encryptedContent: temp[i]);
        }
      }
    }
    return temp;
  }
}
