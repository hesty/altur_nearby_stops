import 'package:latlong2/latlong.dart';
import 'package:altur_nearby_stops/view/map/model/marker_model.dart'; // For TransportType

/// Transport stops constants used throughout the application
final class TransportStopsConstants {
  // Metrobus Stops
  static const List<StopData> metrobusStops = [
    StopData(position: LatLng(40.991442, 29.037863), type: TransportType.metrobus, name: 'Söğütlüçeşme'),
    StopData(position: LatLng(40.999715, 28.693001), type: TransportType.metrobus, name: 'Saadetdere Mah.'),
    StopData(position: LatLng(40.983601, 28.725913), type: TransportType.metrobus, name: 'Avcılar Merk. Ünv. Kamp.'),
    StopData(position: LatLng(41.022058, 28.623512), type: TransportType.metrobus, name: 'Tüyap'),
    StopData(position: LatLng(40.998818, 28.798906), type: TransportType.metrobus, name: 'Sefaköy'),
    StopData(position: LatLng(40.994992, 28.795078), type: TransportType.metrobus, name: 'Beşyol'),
    StopData(position: LatLng(40.987586, 28.790428), type: TransportType.metrobus, name: 'Florya-Bağlar'),
    StopData(position: LatLng(40.985346, 28.782645), type: TransportType.metrobus, name: 'Cennet Mahallesi'),
    StopData(position: LatLng(40.986372, 28.76942), type: TransportType.metrobus, name: 'Küçükçekmece'),
    StopData(position: LatLng(40.978088, 28.745463), type: TransportType.metrobus, name: 'İBB Sosyal Tesisleri'),
  ];

  // Tram Stops
  static const List<StopData> tramStops = [
    StopData(position: LatLng(41.0257, 28.9814), type: TransportType.tram, name: 'Kabataş (T1)'),
    StopData(position: LatLng(41.0166, 28.9738), type: TransportType.tram, name: 'Sultanahmet (T1)'),
    StopData(position: LatLng(41.0166, 28.9587), type: TransportType.tram, name: 'Eminönü (T1/T5)'),
    StopData(position: LatLng(41.0297, 28.9516), type: TransportType.tram, name: 'Balat (T5)'),
  ];

  // Bus Stops
  static const List<StopData> busStops = [
    StopData(position: LatLng(41.0017, 28.9146), type: TransportType.bus, name: 'Cevizlibağ (500T)'),
    StopData(position: LatLng(41.0088, 28.9182), type: TransportType.bus, name: 'Topkapı Panorama 1453 (500T)'),
    StopData(position: LatLng(41.0123, 28.9217), type: TransportType.bus, name: 'Topkapı Alt Geçit (500T)'),
    StopData(position: LatLng(41.0201, 28.9334), type: TransportType.bus, name: 'Edirnekapı Kaleboyu (500T)'),
    StopData(position: LatLng(41.0245, 28.9378), type: TransportType.bus, name: 'Edirnekapi Surdişi (500T)'),
  ];

  // All stops combined
  static List<StopData> get allStops => [...metrobusStops, ...tramStops, ...busStops];
}

/// Data class for transport stop information
class StopData {
  final LatLng position;
  final TransportType type;
  final String name;

  const StopData({required this.position, required this.type, required this.name});
}
