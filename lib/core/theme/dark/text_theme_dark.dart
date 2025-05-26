import 'package:flutter/material.dart';

final class TextThemeDark {
  TextThemeDark._init();
  static TextThemeDark? _instance;
  static final TextThemeDark instance = _instance ??= TextThemeDark._init();

  final TextStyle medium = const TextStyle(fontWeight: FontWeight.w400, fontSize: 14);
}
