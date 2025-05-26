import 'package:flutter/material.dart';

final class TextThemeLight {
  TextThemeLight._init();
  static TextThemeLight? _instance;
  static TextThemeLight? get instance {
    return _instance ??= TextThemeLight._init();
  }

  final TextStyle medium = const TextStyle(fontWeight: FontWeight.w400, fontSize: 14);
}
