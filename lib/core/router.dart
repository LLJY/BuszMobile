/// App router configuration using go_router.
library;

import 'package:go_router/go_router.dart';

import '../features/search/presentation/search_screen.dart';
import '../features/stop_detail/presentation/stop_detail_screen.dart';

// =============================================================================
// Router
// =============================================================================

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/stop/:code',
      builder: (context, state) {
        final code = state.pathParameters['code']!;
        final params = state.uri.queryParameters;
        final name = params['name'] ?? code;
        final lat = double.tryParse(params['lat'] ?? '');
        final lng = double.tryParse(params['lng'] ?? '');
        return StopDetailScreen(
          busStopCode: code,
          busStopName: name,
          stopLatitude: lat,
          stopLongitude: lng,
        );
      },
    ),
  ],
);
