import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'local_database_service.dart';
import 'secure_session_service.dart';

class GpsTrackingService {
  static final GpsTrackingService instance = GpsTrackingService._internal();
  GpsTrackingService._internal();

  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  String? _activeTrackingOrderId;
  bool _isTracking = false;

  final _locationController = StreamController<Position>.broadcast();
  Stream<Position> get locationStream => _locationController.stream;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  String? get activeTrackingOrderId => _activeTrackingOrderId;

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      final bgStatus = await Permission.locationAlways.request();
      print('Background location status: $bgStatus');
      return true;
    }
    return status.isGranted;
  }

  Future<Position?> getCurrentGpsLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return _fallbackPosition();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _fallbackPosition();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _fallbackPosition();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );

      _currentPosition = position;
      await SecureSessionService.instance.saveLastGpsLocation(
        position.latitude,
        position.longitude,
      );

      return position;
    } catch (e) {
      print('Error acquiring current GPS: $e');
      return _fallbackPosition();
    }
  }

  Position _fallbackPosition() {
    return Position(
      longitude: 80.2707,
      latitude: 13.0827,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 12.0,
      altitudeAccuracy: 5.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  Future<void> startLiveTrackingForOrder(String orderId) async {
    _activeTrackingOrderId = orderId;
    _isTracking = true;

    // Get immediate position
    final initialPos = await getCurrentGpsLocation();
    if (initialPos != null) {
      _currentPosition = initialPos;
      await LocalDatabaseService.instance.logGpsLocation(
        orderId: orderId,
        latitude: initialPos.latitude,
        longitude: initialPos.longitude,
        speed: initialPos.speed,
        accuracy: initialPos.accuracy,
        altitude: initialPos.altitude,
      );
    }

    // Cancel any previous stream
    await _positionStreamSubscription?.cancel();

    // Start location telemetry stream
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // update every 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) async {
        _currentPosition = position;
        _locationController.add(position);

        // 1. Log locally in SQLite
        await LocalDatabaseService.instance.logGpsLocation(
          orderId: orderId,
          latitude: position.latitude,
          longitude: position.longitude,
          speed: position.speed,
          accuracy: position.accuracy,
          altitude: position.altitude,
        );

        // 2. Persist in secure session
        await SecureSessionService.instance.saveLastGpsLocation(
          position.latitude,
          position.longitude,
        );

        print('📍 [GPS Track Broadcast] Order $orderId -> Lat: ${position.latitude}, Lng: ${position.longitude}');
      },
      onError: (err) {
        print('GPS stream error: $err');
      },
    );
  }

  Future<void> stopLiveTracking() async {
    _isTracking = false;
    _activeTrackingOrderId = null;
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  Future<Map<String, dynamic>> shareCurrentLocation(String reason) async {
    final pos = await getCurrentGpsLocation() ?? _fallbackPosition();
    print('📍 Shared GPS Location for reason "$reason": (${pos.latitude}, ${pos.longitude})');
    return {
      'latitude': pos.latitude,
      'longitude': pos.longitude,
      'accuracy': pos.accuracy,
      'speed': pos.speed,
      'timestamp': DateTime.now().toIso8601String(),
      'reason': reason,
    };
  }
}
