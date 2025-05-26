import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import 'dark_theme_interface.dart';

/// This Dart code snippet defines a class named `DarkTheme` that extends `AppTheme` and implements
/// `IDarkThemeInterface`. Here's a breakdown of what each part of the code is doing:
final class DarkTheme extends AppTheme with IDarkThemeInterface {
  DarkTheme._init();

  static DarkTheme? _instance;
  static final DarkTheme instance = _instance ??= DarkTheme._init();

  @override
  ThemeData get theme => FlexThemeData.dark(
    scheme: FlexScheme.redM3,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    subThemesData: const FlexSubThemesData(blendOnLevel: 10, blendOnColors: false, useM2StyleDividerInM3: true),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.notoSans().fontFamily,
  );
}
