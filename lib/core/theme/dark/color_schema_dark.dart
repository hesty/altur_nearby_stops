import 'package:flutter/material.dart';

class ColorSchemeDark {
  ColorSchemeDark._init();
  static ColorSchemeDark? _instance;
  static final ColorSchemeDark instance = _instance ??= ColorSchemeDark._init();

  final Color foregroundPrimary = const Color(0xFFe02626);
}
