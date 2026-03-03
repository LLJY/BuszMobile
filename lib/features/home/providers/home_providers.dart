/// Providers for the home screen feature.
///
/// Manages GPS location detection (mobile only) and nearby stops lookup.
library;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/models.dart';
import '../../search/providers/search_providers.dart';

part 'home_providers.g.dart';

// =============================================================================
// Current Location Provider
// =============================================================================

/// User's current GPS location (mobile only).
///
/// Returns `null` on desktop/web platforms, or if location services are
/// disabled or permission was denied. Handles denial gracefully.
@riverpod
Future<Position?> currentLocation(Ref ref) async {
  // Skip GPS entirely on web and desktop platforms
  if (kIsWeb ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows) {
    return null;
  }

  // Check if location services are enabled
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  // Check / request permission
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }
  if (permission == LocationPermission.deniedForever) return null;

  // Get current position with medium accuracy (sufficient for nearby stops)
  return Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
  );
}

// =============================================================================
// Nearby Stops Provider
// =============================================================================

/// Nearby bus stops based on the user's current GPS location.
///
/// Returns an empty list if location is unavailable (desktop/web, denied, etc).
/// Fetches from the Frontline gRPC API via [FrontlineService.findNearbyStops].
@riverpod
Future<List<NearbyStop>> nearbyStops(Ref ref) async {
  final position = await ref.watch(currentLocationProvider.future);
  if (position == null) return [];

  final service = ref.read(frontlineServiceProvider);
  return service.findNearbyStops(position.latitude, position.longitude);
}
