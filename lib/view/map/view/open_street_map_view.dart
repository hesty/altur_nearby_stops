import 'package:altur_nearby_stops/view/map/controller/open_street_map_controller.dart';
import 'package:altur_nearby_stops/view/map/model/marker_model.dart';
import 'package:altur_nearby_stops/view/map/widget/transport_toggle_button.dart';
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
        child: Consumer<OpenStreetMapController>(
          builder: (context, controller, child) {
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
                    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
