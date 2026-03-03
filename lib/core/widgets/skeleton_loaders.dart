/// Shared shimmer skeleton loaders for pending UI states.
// ignore_for_file: prefer_const_constructors
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// =============================================================================
// Arrival Tile Skeleton
// =============================================================================

class ArrivalTileSkeleton extends StatelessWidget {
  const ArrivalTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonShimmer(
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              _SkeletonBox(width: 56, height: 36, radius: 8),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.85,
                      child: _SkeletonBox(height: 14, radius: 6),
                    ),
                    SizedBox(height: 8),
                    FractionallySizedBox(
                      widthFactor: 0.55,
                      child: _SkeletonBox(height: 10, radius: 4),
                    ),
                    SizedBox(height: 6),
                    FractionallySizedBox(
                      widthFactor: 0.4,
                      child: _SkeletonBox(height: 10, radius: 4),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SkeletonBox(width: 44, height: 18, radius: 6),
                  SizedBox(height: 6),
                  _SkeletonBox(width: 30, height: 10, radius: 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Nearby Stop Card Skeleton
// =============================================================================

class NearbyStopCardSkeleton extends StatelessWidget {
  const NearbyStopCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 148,
      child: _SkeletonShimmer(
        child: const Card.filled(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SkeletonBox(width: 58, height: 14, radius: 6),
                    Spacer(),
                    _SkeletonBox(width: 38, height: 18, radius: 5),
                  ],
                ),
                SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: _SkeletonBox(height: 13, radius: 5),
                ),
                SizedBox(height: 6),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: _SkeletonBox(height: 13, radius: 5),
                ),
                Spacer(),
                Row(
                  children: [
                    _SkeletonBox(width: 30, height: 14, radius: 4),
                    SizedBox(width: 4),
                    _SkeletonBox(width: 26, height: 14, radius: 4),
                    SizedBox(width: 4),
                    _SkeletonBox(width: 34, height: 14, radius: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Service Chip Bar Skeleton
// =============================================================================

class ServiceChipSkeleton extends StatelessWidget {
  const ServiceChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: _SkeletonShimmer(
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: const [
            _SkeletonBox(width: 104, height: 32, radius: 8),
            SizedBox(width: 8),
            _SkeletonBox(width: 92, height: 32, radius: 8),
            SizedBox(width: 8),
            _SkeletonBox(width: 116, height: 32, radius: 8),
            SizedBox(width: 8),
            _SkeletonBox(width: 88, height: 32, radius: 8),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Shared Skeleton Helpers
// =============================================================================

class _SkeletonShimmer extends StatelessWidget {
  final Widget child;

  const _SkeletonShimmer({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colors.surfaceContainerHighest,
      highlightColor: colors.surfaceContainerLow,
      child: child,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _SkeletonBox({this.width, required this.height, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
