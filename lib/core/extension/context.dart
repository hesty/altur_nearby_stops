import 'package:flutter/material.dart';

// MediaQueryExtension is an extension on BuildContext that provides methods to get media query data and screen dimensions.
extension MediaQueryExtension on BuildContext {
  // return mediaQuery of app
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  // return height of screen
  double get height => mediaQuery.size.height;
  // return width of screen
  double get width => mediaQuery.size.width;

  double get lowValue => height * 0.01;
  double get mediumValue => height * 0.02;
  double get highValue => height * 0.03;
}

// ThemeExtension is an extension on BuildContext that provides methods to get theme data and color scheme.
extension ThemeExtension on BuildContext {
  // return theme of app
  ThemeData get theme => Theme.of(this);
  // return colorScheme of app
  ColorScheme get colorScheme => theme.colorScheme;
  // return textTheme of app
  TextTheme get textTheme => theme.textTheme;

  // Convenience color getters
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get errorColor => colorScheme.error;
  Color get surfaceColor => colorScheme.surface;
  Color get onSurfaceColor => colorScheme.onSurface;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get onSecondaryColor => colorScheme.onSecondary;

  // Semantic color mappings
  Color get whiteColor => colorScheme.surface;
  Color get redColor => colorScheme.error;
  Color get blueColor => colorScheme.tertiary;
  Color get brownColor => colorScheme.secondary;
}
