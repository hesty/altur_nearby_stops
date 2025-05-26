import 'package:altur_nearby_stops/core/constants/app_constants.dart';
import 'package:altur_nearby_stops/core/init/language/language_manager.dart';
import 'package:altur_nearby_stops/core/init/language/locale_keys.g.dart';
import 'package:altur_nearby_stops/core/init/navigation/navigation_manager.dart';
import 'package:altur_nearby_stops/core/provider/app_provider.dart';
import 'package:altur_nearby_stops/core/provider/theme_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The main function initializes the app, sets up providers, localization, and runs the app.
Future<void> main() async {
  await _appInit();
  runApp(
    MultiProvider(
      providers: AppProvider.instance.providerList,
      child: EasyLocalization(
        supportedLocales: LanguageManager.instance.supportedLocales,
        path: ApplicationConstants.languageAssetsPath,
        startLocale: LanguageManager.instance.en,

        child: const RunApp(),
      ),
    ),
  );
}

/// The `_appInit` function ensures Flutter is initialized, initializes the cache manager, and ensures Easy Localization is initialized.
Future<void> _appInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}

/// The `RunApp` class is a Flutter widget that sets up a MaterialApp with routing and localization configurations.
class RunApp extends StatelessWidget {
  const RunApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeNotifier>().currentTheme,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      title: LocaleKeys.title.tr(),
      routerConfig: NavigationManager().router,
    );
  }
}
