/// App router configuration using go_router.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/route_view/presentation/route_view_screen.dart';
import '../features/stop_detail/presentation/stop_detail_screen.dart';

// =============================================================================
// Router
// =============================================================================

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/stop/:code',
      pageBuilder: (context, state) {
        final code = state.pathParameters['code']!;
        final params = state.uri.queryParameters;
        final name = params['name'] ?? code;
        final lat = double.tryParse(params['lat'] ?? '');
        final lng = double.tryParse(params['lng'] ?? '');
        return _fadeSlidePage(
          state: state,
          child: StopDetailScreen(
            busStopCode: code,
            busStopName: name,
            stopLatitude: lat,
            stopLongitude: lng,
          ),
        );
      },
    ),
    GoRoute(
      path: '/route/:serviceNo',
      pageBuilder: (context, state) {
        final serviceNo = state.pathParameters['serviceNo']!;
        final highlightStop = state.uri.queryParameters['highlight'];
        return _fadeSlidePage(
          state: state,
          child: RouteViewScreen(
            serviceNo: serviceNo,
            highlightStopCode: highlightStop,
          ),
        );
      },
    ),
  ],
);

CustomTransitionPage<void> _fadeSlidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}
