import 'package:altur_nearby_stops/view/map/model/marker_model.dart';
import 'package:altur_nearby_stops/view/map/model/transport_stop_model.dart';
import 'package:altur_nearby_stops/core/extension/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapController extends ChangeNotifier {
  final MapController _mapController = MapController();
  MapController get mapController => _mapController;

  AnimationController? _animationController;
  Animation<double>? _animation;

  final List<Marker> _allMarkers = [];
  final List<Marker> _visibleMarkers = [];
  List<Marker> get markers => _visibleMarkers;

  // Visibility states for each transport type
  bool _isBusVisible = true;
  bool _isMetrobusVisible = true;
  bool _isTramVisible = true;

  // Getters for visibility states
  bool get isBusVisible => _isBusVisible;
  bool get isMetrobusVisible => _isMetrobusVisible;
  bool get isTramVisible => _isTramVisible;

  BuildContext? _context;

  OpenStreetMapController();

  void initializeWithContext(BuildContext context) {
    _context = context;
    _initializeStops();
  }

  void _initializeStops() {
    if (_context == null) return;

    // Create markers from constants
    for (final stopData in TransportStopsConstants.allStops) {
      _allMarkers.add(_createMarker(position: stopData.position, type: stopData.type, name: stopData.name));
    }
    _updateVisibleMarkers();
  }

  void _updateVisibleMarkers() {
    _visibleMarkers.clear();
    for (int i = 0; i < _allMarkers.length; i++) {
      final stopData = TransportStopsConstants.allStops[i];
      bool shouldShow = false;

      switch (stopData.type) {
        case TransportType.bus:
          shouldShow = _isBusVisible;
          break;
        case TransportType.metrobus:
          shouldShow = _isMetrobusVisible;
          break;
        case TransportType.tram:
          shouldShow = _isTramVisible;
          break;
      }

      if (shouldShow) {
        _visibleMarkers.add(_allMarkers[i]);
      }
    }
    notifyListeners();
  }

  void toggleBus() {
    _isBusVisible = !_isBusVisible;
    _updateVisibleMarkers();
  }

  void toggleMetrobus() {
    _isMetrobusVisible = !_isMetrobusVisible;
    _updateVisibleMarkers();
  }

  void toggleTram() {
    _isTramVisible = !_isTramVisible;
    _updateVisibleMarkers();
  }

  void initializeAnimation(TickerProvider tickerProvider) {
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: tickerProvider);
  }

  void animateToAvcilar() {
    if (_animationController == null) return;

    //istanbul
    const startLatLng = LatLng(41.0082, 28.9784);
    //avcılar
    const endLatLng = LatLng(40.9792, 28.7214);
    // start zoom
    const startZoom = 12.0;
    const endZoom = 14.0;

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut));

    _animationController!.addListener(() {
      final t = _animation!.value;
      final lat = startLatLng.latitude + (endLatLng.latitude - startLatLng.latitude) * t;
      final lng = startLatLng.longitude + (endLatLng.longitude - startLatLng.longitude) * t;
      final zoom = startZoom + (endZoom - startZoom) * t;

      _mapController.move(LatLng(lat, lng), zoom);
    });

    _animationController!.forward();
  }

  void resetAnimation() {
    _animationController?.reset();
  }

  Marker _createMarker({required LatLng position, required TransportType type, required String name}) {
    if (_context == null) throw Exception('Context not initialized');

    final config = MarkerModel.fromTransportType(type, _context!);

    return Marker(
      point: position,
      width: config.size,
      height: config.size,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
        },
        child: Container(
          decoration: BoxDecoration(
            color: config.color,
            shape: BoxShape.circle,
            border: Border.all(color: _context!.whiteColor, width: 2),
          ),
          child: Icon(config.icon, color: _context!.whiteColor, size: config.iconSize),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
