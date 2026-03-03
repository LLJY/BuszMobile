/// Provider for fetching all services available at a bus stop.
///
/// Uses [FrontlineService.getServicesAtStop] to provide a complete service
/// directory, independent of the arrivals polling stream.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/models.dart';
import '../../search/providers/search_providers.dart';

part 'services_at_stop_provider.g.dart';

/// Fetches all bus services available at a stop.
///
/// Auto-disposes when the stop detail screen is left.
/// This is a one-shot fetch (not polled) since the service list
/// changes infrequently.
@riverpod
Future<List<ServiceSummary>> servicesAtStop(Ref ref, String busStopCode) async {
  final service = ref.watch(frontlineServiceProvider);
  return service.getServicesAtStop(busStopCode);
}
