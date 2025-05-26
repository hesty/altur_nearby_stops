import 'package:altur_nearby_stops/core/provider/app_provider.dart';
import 'package:altur_nearby_stops/core/provider/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The main function initializes the app, sets up providers, localization, and runs the app.
Future<void> main() async {
  await _appInit();
  runApp(MultiProvider(providers: AppProvider.instance.providerList, child: const RunApp()));
}

/// The `_appInit` function ensures Flutter is initialized, initializes the cache manager, and ensures Easy Localization is initialized.
Future<void> _appInit() async {
  WidgetsFlutterBinding.ensureInitialized();
}

/// The `RunApp` class is a Flutter widget that sets up a MaterialApp with routing and localization configurations.
class RunApp extends StatelessWidget {
  const RunApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeNotifier>().currentTheme,
      home: Scaffold(appBar: AppBar(title: const Text('Altur Nearby Stops'))),
    );
  }
}
