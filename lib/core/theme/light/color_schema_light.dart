import 'package:flutter/material.dart';

class ColorSchemeLight {
  ColorSchemeLight._init();
  static ColorSchemeLight? _instance;
  static final ColorSchemeLight instance = _instance ??= ColorSchemeLight._init();

  final Color foregroundPrimary = const Color(0xFFe02626);
}
