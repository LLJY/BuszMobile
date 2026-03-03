/// Providers for the route view feature.
///
/// Fetches service route details (polyline, stops) via GetServiceDetails RPC.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/models.dart';
import '../../search/providers/search_providers.dart';

part 'route_providers.g.dart';

// =============================================================================
// Service Route Provider
// =============================================================================

/// Fetches full route details for a bus service.
///
/// Auto-disposes when the route view screen is left.
@riverpod
Future<ServiceRouteData> serviceRoute(Ref ref, String serviceNo) async {
  final service = ref.watch(frontlineServiceProvider);
  return service.getServiceDetails(serviceNo);
}
