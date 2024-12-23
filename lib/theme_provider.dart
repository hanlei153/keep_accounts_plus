import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // 初始为系统主题
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // 开关状态
  bool get isSystemTheme => _themeMode == ThemeMode.system;

  // 切换主题模式
  void toggleTheme(bool isSystemTheme) {
    _themeMode = isSystemTheme ? ThemeMode.system : ThemeMode.light;
    _saveThemeStatus(isSystemTheme ? 'system' : 'light');
    notifyListeners(); // 通知所有监听者更新状态
  }

  // 保存主题状态到 SharedPreferences
  Future<void> _saveThemeStatus(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ThemeStatus', themeMode);
  }

  // 从 SharedPreferences 加载主题状态
  Future<void> loadThemeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStatus = prefs.getString('ThemeStatus');
    if (themeStatus != null) {
      if (themeStatus == 'system') {
        _themeMode = ThemeMode.system;
      } else if (themeStatus == 'light') {
        _themeMode = ThemeMode.light;
      } else if (themeStatus == 'dark') {
        _themeMode = ThemeMode.dark;
      }
      notifyListeners(); // 通知所有监听者更新状态
    }
  }
}
