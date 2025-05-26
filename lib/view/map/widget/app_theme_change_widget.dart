import 'package:altur_nearby_stops/core/constants/enum/app_theme_enum.dart';
import 'package:altur_nearby_stops/core/constants/enum/lottie_enum.dart';
import 'package:altur_nearby_stops/core/provider/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppThemeChangeWidget extends StatelessWidget {
  const AppThemeChangeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<ThemeNotifier>().changeTheme(),
      icon: SizedBox(
        width: 24,
        height: 24,
        child: context.watch<ThemeNotifier>().currentThemeEnum == AppThemes.light
            ? LottieEnum.moon.toWidget
            : LottieEnum.sunny.toWidget,
      ),
    );
  }
}
