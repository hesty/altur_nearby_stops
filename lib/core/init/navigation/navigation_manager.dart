import 'package:altur_nearby_stops/view/map/controller/open_street_map_controller.dart';
import 'package:altur_nearby_stops/view/map/view/open_street_map_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum NavigationEnum { map }

extension NavigationEnumExtension on NavigationEnum {
  String get rawValue {
    switch (this) {
      case NavigationEnum.map:
        return '/';
    }
  }
}

/// The `NavigationManager` class is a singleton class that manages navigation using the `GoRouter`
@immutable
class NavigationManager {
  factory NavigationManager() => _instance;
  NavigationManager._internal();
  static final NavigationManager _instance = NavigationManager._internal();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: NavigationEnum.map.rawValue,
    routes: <RouteBase>[
      GoRoute(
        path: NavigationEnum.map.rawValue,
        builder: (BuildContext context, GoRouterState state) =>
            ChangeNotifierProvider(create: (context) => OpenStreetMapController(), child: OpenStreetMapView()),
      ),
    ],
  );

  ///return router object
  GoRouter get router => _router;
}
