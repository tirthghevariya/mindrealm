import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String? get dailyRemider => _prefsInstance?.getString("dailyRemider");
  static set dailyRemider(String? value) =>
      _prefsInstance?.setString("dailyRemider", value!);

  static String? get weeklyRemider =>
      _prefsInstance?.getString("weeklyRemider");
  static set weeklyRemider(String? value) =>
      _prefsInstance?.setString("weeklyRemider", value!);

  static String? get healRemider => _prefsInstance?.getString("healRemider");
  static set healRemider(String? value) =>
      _prefsInstance?.setString("healRemider", value!);

  static String? get goalRemider => _prefsInstance?.getString("goalRemider");
  static set goalRemider(String? value) =>
      _prefsInstance?.setString("goalRemider", value!);

  static Future<void> clearStorage() async {
    await Storage._prefsInstance?.clear();
  }
}
