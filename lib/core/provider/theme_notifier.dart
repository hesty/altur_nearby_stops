import 'package:altur_nearby_stops/core/constants/enum/app_theme_enum.dart';
import 'package:altur_nearby_stops/core/theme/dark/dark_theme.dart';
import 'package:altur_nearby_stops/core/theme/light/light_theme.dart';
import 'package:flutter/material.dart';

/// changing the theme between light and dark.
final class ThemeNotifier extends ChangeNotifier {
  AppThemes _currentThemeEnum = AppThemes.light;
  ThemeData _currentThemeData = LightTheme.instance!.theme;

  /// default value is [AppThemes.light]
  AppThemes get currentThemeEnum => _currentThemeEnum;

  ThemeData get currentTheme => _currentThemeData;

  /// change app theme with [currentThemeEnum] value.
  void changeTheme() {
    if (_currentThemeEnum == AppThemes.light) {
      _currentThemeData = DarkTheme.instance.theme;
      _currentThemeEnum = AppThemes.dark;
    } else {
      _currentThemeData = LightTheme.instance!.theme;
      _currentThemeEnum = AppThemes.light;
    }
    notifyListeners();
  }
}
