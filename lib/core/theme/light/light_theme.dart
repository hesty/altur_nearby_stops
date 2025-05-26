import 'package:altur_nearby_stops/core/theme/light/light_theme_interface.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

final class LightTheme extends AppTheme with ILightThemeInterface {
  LightTheme._init();

  static LightTheme? _instance;
  static LightTheme? get instance {
    return _instance ??= LightTheme._init();
  }

  @override
  ThemeData get theme => FlexThemeData.light(
    scheme: FlexScheme.redM3,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useM2StyleDividerInM3: true,
      useMaterial3Typography: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.notoSans().fontFamily,
  );
}
