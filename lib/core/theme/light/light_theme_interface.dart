import 'color_schema_light.dart';
import 'text_theme_light.dart';

mixin class ILightThemeInterface {
  TextThemeLight? textThemeLight = TextThemeLight.instance;
  ColorSchemeLight? colorSchemeLight = ColorSchemeLight.instance;
}
