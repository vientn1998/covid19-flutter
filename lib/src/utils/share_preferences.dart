import 'package:shared_preferences/shared_preferences.dart';

import 'define.dart';

class SharePreferences {
  static final SharePreferences _sharePreferences = SharePreferences._internal();

  factory SharePreferences() {
    return _sharePreferences;
  }

  SharePreferences._internal();

  saveBool(SharePreferenceKey key, bool value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(key.toString(), value);
    print('save $key-$value');
  }

  saveString(SharePreferenceKey key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key.toString(), value);
    print('save $key-$value');
  }

  Future<bool> getBool(SharePreferenceKey key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool boolValue = _prefs.getBool(key.toString());
    print('get $key-$boolValue');
    return boolValue;
  }


}