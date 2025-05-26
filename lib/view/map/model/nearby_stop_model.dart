import 'package:altur_nearby_stops/view/map/model/transport_stop_model.dart';

/// Model for nearby stops with distance information
class NearbyStopModel {
  final StopData stopData;
  final double distanceInMeters;
  final String formattedDistance;

  NearbyStopModel({required this.stopData, required this.distanceInMeters})
    : formattedDistance = _formatDistance(distanceInMeters);

  static String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }
}
