import 'package:altur_nearby_stops/view/map/model/marker_model.dart';
import 'package:altur_nearby_stops/view/map/model/transport_stop_model.dart';
import 'package:altur_nearby_stops/view/map/model/nearby_stop_model.dart';
import 'package:altur_nearby_stops/core/extension/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class OpenStreetMapController extends ChangeNotifier {
  final MapController _mapController = MapController();
  MapController get mapController => _mapController;

  AnimationController? _animationController;
  Animation<double>? _animation;

  // Separate animation controller for marker clicks
  AnimationController? _markerAnimationController;
  Animation<double>? _markerAnimation;

  final List<Marker> _allMarkers = [];
  final List<Marker> _visibleMarkers = [];
  Marker? _userLocationMarker;
  List<Marker> get markers =>
      _userLocationMarker != null ? [..._visibleMarkers, _userLocationMarker!] : _visibleMarkers;

  // Visibility states for each transport type
  bool _isBusVisible = true;
  bool _isMetrobusVisible = true;
  bool _isTramVisible = true;

  // Getters for visibility states
  bool get isBusVisible => _isBusVisible;
  bool get isMetrobusVisible => _isMetrobusVisible;
  bool get isTramVisible => _isTramVisible;

  // Nearby stops functionality
  List<NearbyStopModel> _nearbyStops = [];
  List<NearbyStopModel> get nearbyStops => _nearbyStops;
  LatLng? _userLocation;

  // Polyline for route to selected stop
  Polyline? _routePolyline;
  Polyline? get routePolyline => _routePolyline;

  // Scroll controller for nearby stops list
  ScrollController? _nearbyStopsScrollController;

  // Location permission status
  bool _isLocationPermissionDenied = false;
  bool get isLocationPermissionDenied => _isLocationPermissionDenied;

  // Location services status
  bool _isLocationServicesDisabled = false;
  bool get isLocationServicesDisabled => _isLocationServicesDisabled;

  BuildContext? _context;

  OpenStreetMapController();

  void initializeWithContext(BuildContext context) {
    _context = context;
    _initializeStops();
    // Automatically get user location on startup
    _tryGetLocationOnStartup();
  }

  /// Try to get user location on app startup without showing permission dialogs
  Future<void> _tryGetLocationOnStartup() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }

      // If we have permission, get the location
      final position = await Geolocator.getCurrentPosition();
      final userLocation = LatLng(position.latitude, position.longitude);

      // Store user location for proximity calculations
      _userLocation = userLocation;

      // Clear any existing route
      clearRoute();

      // Create and add user location marker
      _userLocationMarker = _createUserLocationMarker(userLocation);

      // Calculate nearby stops
      _calculateNearbyStops();

      notifyListeners();
    } catch (e) {
      // Silently handle errors on startup
    }
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
    // Update nearby stops list if user location is available
    if (_userLocation != null) {
      _calculateNearbyStops();
    }
  }

  void toggleMetrobus() {
    _isMetrobusVisible = !_isMetrobusVisible;
    _updateVisibleMarkers();
    // Update nearby stops list if user location is available
    if (_userLocation != null) {
      _calculateNearbyStops();
    }
  }

  void toggleTram() {
    _isTramVisible = !_isTramVisible;
    _updateVisibleMarkers();
    // Update nearby stops list if user location is available
    if (_userLocation != null) {
      _calculateNearbyStops();
    }
  }

  void initializeAnimation(TickerProvider tickerProvider) {
    _animationController = AnimationController(duration: const Duration(milliseconds: 4000), vsync: tickerProvider);
    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: tickerProvider,
    );
  }

  void animateToAvcilar() {
    if (_animationController == null) return;

    //istanbul
    const startLatLng = LatLng(41.0082, 28.9784);
    //avcılar
    const endLatLng = LatLng(40.9792, 28.7214);
    // start zoom
    const startZoom = 12.0;
    const endZoom = 13.0;

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

  /// The `_animateToPosition` function animates the map marker to a target position with a zoom effect.
  ///
  /// Args:
  ///   targetPosition (LatLng): The `_animateToPosition` function you provided is responsible for
  /// animating the movement of a marker on a map to a target position with a smooth transition. The
  /// function calculates the intermediate positions and zoom levels to create a smooth animation effect.
  ///
  /// Returns:
  ///   If the `_markerAnimationController` is `null`, the function will return early and nothing will be
  /// executed beyond that point.
  void _animateToPosition(LatLng targetPosition) {
    if (_markerAnimationController == null) return;

    // Reset animation controller completely
    _markerAnimationController!.reset();

    final currentPosition = _mapController.camera.center;
    final currentZoom = _mapController.camera.zoom;
    // Always zoom in a bit more for better detail
    final targetZoom = currentZoom < 14.0 ? 14.0 : currentZoom + 0.5;

    _markerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _markerAnimationController!, curve: Curves.easeInOutCubic));

    void animationListener() {
      if (_markerAnimation == null) return;
      final t = _markerAnimation!.value;
      final lat = currentPosition.latitude + (targetPosition.latitude - currentPosition.latitude) * t;
      final lng = currentPosition.longitude + (targetPosition.longitude - currentPosition.longitude) * t;
      final zoom = currentZoom + (targetZoom - currentZoom) * t;

      _mapController.move(LatLng(lat, lng), zoom);
    }

    void statusListener(AnimationStatus status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _markerAnimationController!.removeListener(animationListener);
        _markerAnimationController!.removeStatusListener(statusListener);
      }
    }

    _markerAnimationController!.addListener(animationListener);
    _markerAnimationController!.addStatusListener(statusListener);
    _markerAnimationController!.forward();
  }

  Marker _createMarker({required LatLng position, required TransportType type, required String name}) {
    if (_context == null) throw Exception('Context not initialized');

    final config = MarkerModel.fromTransportType(type, _context!);

    return Marker(
      point: position,
      width: config.size,
      height: config.size,
      rotate: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          _animateToPosition(position);
          // Draw polyline from user location to clicked marker
          _drawRouteToStop(position);
          // Scroll to the clicked stop in the nearby stops list
          scrollToStopInList(position);
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

  Marker _createUserLocationMarker(LatLng position) {
    if (_context == null) throw Exception('Context not initialized');

    return Marker(
      point: position,
      width: 40,
      height: 40,
      rotate: true,
      child: Container(
        decoration: BoxDecoration(
          color: _context!.colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(color: _context!.whiteColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: _context!.colorScheme.primary.withAlpha(102),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.person_pin_circle, color: _context!.whiteColor, size: 24),
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled = false;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      _isLocationServicesDisabled = true;
      _isLocationPermissionDenied = false; // Reset permission denied state
      notifyListeners();
      return Future.error('Location services are disabled.');
    } else {
      // Location services are enabled, reset the disabled state
      _isLocationServicesDisabled = false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission - this will show the native dialog
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isLocationPermissionDenied = true;
        notifyListeners();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isLocationPermissionDenied = true;
      notifyListeners();
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /// Get user's current location and animate to it
  Future<void> getCurrentLocation() async {
    try {
      final position = await _determinePosition();
      final userLocation = LatLng(position.latitude, position.longitude);

      // Store user location for proximity calculations
      _userLocation = userLocation;

      // Clear any existing route
      clearRoute();

      // Create and add user location marker
      _userLocationMarker = _createUserLocationMarker(userLocation);

      // Calculate nearby stops
      _calculateNearbyStops();

      // Reset both permission denied and services disabled states if location was successfully obtained
      _isLocationPermissionDenied = false;
      _isLocationServicesDisabled = false;

      _animateToPosition(userLocation);
      HapticFeedback.heavyImpact();
      notifyListeners();
    } catch (e) {
      // Handle location permission errors
      debugPrint('Location error: $e');
    }
  }

  /// Check and update location permission status
  Future<void> checkLocationPermissionStatus() async {
    try {
      // First check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isLocationServicesDisabled = true;
        _isLocationPermissionDenied = false;
        notifyListeners();
        return;
      }

      // If services are enabled, check permissions
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        _isLocationPermissionDenied = false;
        _isLocationServicesDisabled = false;
        notifyListeners();
        // Try to get location if permission is now granted
        getCurrentLocation();
      } else if (permission == LocationPermission.deniedForever) {
        _isLocationPermissionDenied = true;
        _isLocationServicesDisabled = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error checking location permission: $e');
    }
  }

  Future<void> checkLocationServicesStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    _isLocationServicesDisabled = !serviceEnabled;
    notifyListeners();
  }

  /// Calculate visible stops sorted by distance to user's location
  void _calculateNearbyStops() {
    if (_userLocation == null) return;

    final List<NearbyStopModel> visibleStopsWithDistance = [];

    // Calculate distance only for visible stops
    for (final stopData in TransportStopsConstants.allStops) {
      // Check if this stop type is visible
      bool shouldInclude = false;
      switch (stopData.type) {
        case TransportType.bus:
          shouldInclude = _isBusVisible;
          break;
        case TransportType.metrobus:
          shouldInclude = _isMetrobusVisible;
          break;
        case TransportType.tram:
          shouldInclude = _isTramVisible;
          break;
      }

      // Only include visible stops
      if (shouldInclude) {
        final distance = Geolocator.distanceBetween(
          _userLocation!.latitude,
          _userLocation!.longitude,
          stopData.position.latitude,
          stopData.position.longitude,
        );

        visibleStopsWithDistance.add(NearbyStopModel(stopData: stopData, distanceInMeters: distance));
      }
    }

    // Sort by distance from nearest to farthest
    visibleStopsWithDistance.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));
    _nearbyStops = visibleStopsWithDistance;
  }

  /// Animate to a specific stop from the nearby stops list
  void animateToNearbyStop(NearbyStopModel nearbyStop) {
    _animateToPosition(nearbyStop.stopData.position);
    _drawRouteToStop(nearbyStop.stopData.position);
    HapticFeedback.lightImpact();
  }

  /// Draw a polyline from user location to selected stop
  void _drawRouteToStop(LatLng stopPosition) {
    if (_userLocation == null || _context == null) return;

    _routePolyline = Polyline(
      points: [_userLocation!, stopPosition],
      strokeWidth: 3.0,
      color: _context!.colorScheme.primary,
    );

    notifyListeners();
  }

  /// Clear the route polyline
  void clearRoute() {
    _routePolyline = null;
    notifyListeners();
  }

  /// Set the scroll controller for the nearby stops list
  void setNearbyStopsScrollController(ScrollController scrollController) {
    _nearbyStopsScrollController = scrollController;
  }

  /// Scroll to a specific stop in the nearby stops list
  void scrollToStopInList(LatLng stopPosition) {
    if (_nearbyStopsScrollController == null || _nearbyStops.isEmpty) return;

    // Find the index of the stop in the nearby stops list
    final stopIndex = _nearbyStops.indexWhere(
      (nearbyStop) =>
          nearbyStop.stopData.position.latitude == stopPosition.latitude &&
          nearbyStop.stopData.position.longitude == stopPosition.longitude,
    );

    if (stopIndex != -1) {
      // Calculate the scroll position (each card is 200 width + 12 margin)
      const cardWidth = 200.0;
      const cardMargin = 12.0;
      const listPadding = 16.0;

      final scrollPosition = (stopIndex * (cardWidth + cardMargin)) - listPadding;

      // Animate to the calculated position
      _nearbyStopsScrollController!.animateTo(
        scrollPosition.clamp(0.0, _nearbyStopsScrollController!.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _markerAnimationController?.dispose();
    super.dispose();
  }
}
