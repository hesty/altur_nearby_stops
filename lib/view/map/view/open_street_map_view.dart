import 'package:altur_nearby_stops/view/map/controller/open_street_map_controller.dart';
import 'package:altur_nearby_stops/view/map/model/marker_model.dart';
import 'package:altur_nearby_stops/view/map/widget/transport_toggle_button.dart';
import 'package:altur_nearby_stops/view/map/widget/change_language_widget.dart';
import 'package:altur_nearby_stops/view/map/widget/app_theme_change_widget.dart';
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

class _OpenStreetMapViewState extends State<OpenStreetMapView> with TickerProviderStateMixin {
  @override
  void initState() {
    // context read open street map controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<OpenStreetMapController>();
      controller.initializeWithContext(context);
      controller.initializeAnimation(this);
    });

    super.initState();
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
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      tileBuilder: themeNotifier.currentThemeEnum == AppThemes.dark ? darkModeTileBuilder : null,
                      userAgentPackageName: 'com.altur.nearby_stops',
                    ),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
