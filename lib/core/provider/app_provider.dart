// AppProvider is a singleton that manages providers for the app
import 'package:altur_nearby_stops/core/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final class AppProvider {
  AppProvider._init();
  static AppProvider? _instance;
  static final AppProvider instance = _instance ??= AppProvider._init();

  // providerList is a list of providers for the app
  List<SingleChildWidget> providerList = [ChangeNotifierProvider(create: (context) => ThemeNotifier())];
}
