import 'package:altur_nearby_stops/core/extension/context.dart';
import 'package:altur_nearby_stops/core/init/language/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.setLocale(
        context.locale == LanguageManager.instance.tr ? LanguageManager.instance.en : LanguageManager.instance.tr,
      ),
      child: context.locale == LanguageManager.instance.tr
          ? Text('EN', style: context.textTheme.labelLarge)
          : Text('TR', style: context.textTheme.labelLarge),
    );
  }
}
