import 'package:altur_nearby_stops/view/map/controller/open_street_map_controller.dart';
import 'package:altur_nearby_stops/view/map/model/marker_model.dart';
import 'package:altur_nearby_stops/view/map/widget/transport_toggle_button.dart';
import 'package:altur_nearby_stops/view/map/widget/change_language_widget.dart';
import 'package:altur_nearby_stops/view/map/widget/app_theme_change_widget.dart';
import 'package:altur_nearby_stops/view/map/widget/nearby_stops_list.dart';
import 'package:altur_nearby_stops/view/map/widget/location_permission_banner.dart';
import 'package:altur_nearby_stops/view/map/widget/location_services_banner.dart';
import 'package:altur_nearby_stops/core/extension/context.dart';
import 'package:altur_nearby_stops/core/constants/enum/app_theme_enum.dart';
import 'package:altur_nearby_stops/core/provider/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class OpenStreetMapView extends StatefulWidget {
  const OpenStreetMapView({super.key});

  @override
  State<OpenStreetMapView> createState() => _OpenStreetMapViewState();
}

class _OpenStreetMapViewState extends State<OpenStreetMapView> with TickerProviderStateMixin, WidgetsBindingObserver {
  final tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // context read open street map controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<OpenStreetMapController>();
      controller.initializeWithContext(context);
      controller.initializeAnimation(this);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Check location permission when app resumes (user might have changed settings)
      final controller = context.read<OpenStreetMapController>();
      controller.checkLocationPermissionStatus();
      controller.checkLocationServicesStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer2<OpenStreetMapController, ThemeNotifier>(
          builder: (context, controller, themeNotifier, child) {
            return Stack(
              children: [
                FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(41.0082, 28.9784),
                    initialZoom: 12,
                    maxZoom: 18,
                    minZoom: 3,
                    onMapReady: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      controller.animateToAvcilar();
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: tileUrl,
                      tileBuilder: themeNotifier.currentThemeEnum == AppThemes.dark ? darkModeTileBuilder : null,
                    ),
                    if (controller.routePolyline != null) PolylineLayer(polylines: [controller.routePolyline!]),
                    MarkerLayer(markers: controller.markers),
                  ],
                ),

                // Toggle buttons positioned in the top-left corner
                Positioned(
                  top: 16,
                  left: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransportToggleButton(
                        transportType: TransportType.metrobus,
                        isVisible: controller.isMetrobusVisible,
                        onToggle: controller.toggleMetrobus,
                      ),
                      const SizedBox(height: 8),
                      TransportToggleButton(
                        transportType: TransportType.bus,
                        isVisible: controller.isBusVisible,
                        onToggle: controller.toggleBus,
                      ),
                      const SizedBox(height: 8),
                      TransportToggleButton(
                        transportType: TransportType.tram,
                        isVisible: controller.isTramVisible,
                        onToggle: controller.toggleTram,
                      ),
                    ],
                  ),
                ),

                // Language and theme widgets positioned in the top-right corner
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colorScheme.onPrimary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.shadow.withAlpha(51),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [const AppThemeChangeWidget(), const SizedBox(height: 4), const ChangeLanguageWidget()],
                    ),
                  ),
                ),

                // Location button positioned in the bottom-right corner
                Positioned(
                  bottom:
                      (controller.nearbyStops.isNotEmpty &&
                          !controller.isLocationPermissionDenied &&
                          !controller.isLocationServicesDisabled)
                      ? 176
                      : 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => controller.getCurrentLocation(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.colorScheme.onPrimary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.shadow.withAlpha(51),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.near_me, color: context.colorScheme.onPrimary, size: 24),
                    ),
                  ),
                ),

                // Location services banner when services are disabled
                if (controller.isLocationServicesDisabled)
                  const Positioned(bottom: 0, left: 0, right: 0, child: LocationServicesBanner()),

                // Location permission banner when permission is denied
                if (controller.isLocationPermissionDenied)
                  const Positioned(bottom: 0, left: 0, right: 0, child: LocationPermissionBanner()),

                // Nearby stops list positioned at the bottom
                if (!controller.isLocationPermissionDenied && !controller.isLocationServicesDisabled)
                  const Positioned(bottom: 0, left: 0, right: 0, child: NearbyStopsList()),
              ],
            );
          },
        ),
      ),
    );
  }
}
