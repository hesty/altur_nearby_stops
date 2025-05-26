import 'package:flutter/material.dart';
import 'package:altur_nearby_stops/core/extension/context.dart';

enum TransportType { metrobus, bus, tram }

class MarkerModel {
  final Color color;
  final IconData icon;
  final double size;
  final double iconSize;

  MarkerModel({required this.color, required this.icon, required this.size, required this.iconSize});

  factory MarkerModel.fromTransportType(TransportType type, BuildContext context) {
    switch (type) {
      case TransportType.metrobus:
        return MarkerModel(color: context.redColor, icon: Icons.subway, size: 40.0, iconSize: 16.0);
      case TransportType.bus:
        return MarkerModel(color: context.blueColor, icon: Icons.directions_bus, size: 40.0, iconSize: 14.0);
      case TransportType.tram:
        return MarkerModel(color: context.brownColor, icon: Icons.tram, size: 40.0, iconSize: 14.0);
    }
  }
}
