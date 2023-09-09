import 'package:shared_preferences/shared_preferences.dart';

class UtilSharedPreferences {
  static Future<String?> getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('theme');
  }

  static Future<void> setTheme(String theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('theme', theme);
  }

  static Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('token');
  }

  static Future<void> setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', token);
  }

  static Future<void> removeToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(token);
  }

  static Future<void> setFormData(String email, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('email', email);
    await preferences.setString('password', password);
  }

  static Future<Map<String, String>> getFormData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final email = preferences.getString('email');
    final password = preferences.getString('password');
    if (email != null && password != null) {
      return {
        'email': email,
        'password': password,
      };
    } else {
      return {};
    }
  }

  static Future<void> removeFormData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('email');
    await preferences.remove('password');
  }

  static Future<String?> getCheckId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('checkId');
  }

  static Future<void> setCheckId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('checkId', id);
  }

  static Future<void> removeCheckId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('checkId');
  }
}
