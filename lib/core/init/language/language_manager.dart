import 'package:flutter/material.dart';

// LanguageManager is a singleton that manages supported locales for app
final class LanguageManager {
  LanguageManager._init();
  static LanguageManager? _instance;
  static final LanguageManager instance = _instance ??= LanguageManager._init();

  final en = const Locale('en', 'US');
  final tr = const Locale('tr', 'TR');

  List<Locale> get supportedLocales => [en, tr];
}
