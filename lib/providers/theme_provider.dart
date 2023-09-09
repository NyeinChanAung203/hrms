import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/utils/shared_pre_util.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode get themeMode => _themeMode;

  ThemeMode _themeMode = ThemeMode.light;

  Future<void> getThemeMode() async {
    final theme = await UtilSharedPreferences.getTheme();
    log(theme ?? 'theme is null');
    if (theme == null) {
      _themeMode = ThemeMode.light;
    } else {
      if (theme == 'light') {
        _themeMode = ThemeMode.light;
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ));
      } else {
        _themeMode = ThemeMode.dark;
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black, // navigation bar color
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ));
      }
    }
    notifyListeners();
  }

  changeThemeMode(ThemeMode previousThemMode) async {
    if (previousThemMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      await UtilSharedPreferences.setTheme('dark');
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black, // navigation bar color
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    } else {
      _themeMode = ThemeMode.light;
      await UtilSharedPreferences.setTheme('light');
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
    notifyListeners();
  }
}
