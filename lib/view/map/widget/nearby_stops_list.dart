import 'package:altur_nearby_stops/view/map/controller/open_street_map_controller.dart';
import 'package:altur_nearby_stops/view/map/model/marker_model.dart';
import 'package:altur_nearby_stops/view/map/model/nearby_stop_model.dart';
import 'package:altur_nearby_stops/core/extension/context.dart';
import 'package:altur_nearby_stops/core/init/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearbyStopsList extends StatelessWidget {
  const NearbyStopsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OpenStreetMapController>(
      builder: (context, controller, child) {
        if (controller.nearbyStops.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 160,
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  LocaleKeys.nearby_stops.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.nearbyStops.length,
                  itemBuilder: (context, index) {
                    final nearbyStop = controller.nearbyStops[index];
                    return _NearbyStopCard(
                      nearbyStop: nearbyStop,
                      onTap: () => controller.animateToNearbyStop(nearbyStop),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NearbyStopCard extends StatelessWidget {
  final NearbyStopModel nearbyStop;
  final VoidCallback onTap;

  const _NearbyStopCard({required this.nearbyStop, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final config = MarkerModel.fromTransportType(nearbyStop.stopData.type, context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colorScheme.outline.withAlpha(51)),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withAlpha(25),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: config.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.whiteColor, width: 2),
                  ),
                  child: Icon(config.icon, color: context.whiteColor, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getTransportTypeName(nearbyStop.stopData.type),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              nearbyStop.stopData.name,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: context.colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  nearbyStop.formattedDistance,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTransportTypeName(TransportType type) {
    switch (type) {
      case TransportType.metrobus:
        return LocaleKeys.transport_type_metrobus.tr();
      case TransportType.bus:
        return LocaleKeys.transport_type_bus.tr();
      case TransportType.tram:
        return LocaleKeys.transport_type_tram.tr();
    }
  }
}
