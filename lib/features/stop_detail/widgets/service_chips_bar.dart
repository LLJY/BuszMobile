/// Horizontal scrollable bar of service chips for the stop detail screen.
///
/// Shows ALL services at a bus stop (from GetServicesAtStop RPC),
/// regardless of whether they currently have active arrivals.
/// Tapping a chip selects/deselects that service filter.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';
import '../providers/services_at_stop_provider.dart';

// =============================================================================
// Service Chips Bar
// =============================================================================

/// A horizontal scrollable row of service chips.
///
/// Each chip displays the service number in its route color,
/// the destination below, and a "FREE" badge if applicable.
/// Tapping a chip calls [onServiceTap] with the service number.
class ServiceChipsBar extends ConsumerWidget {
  /// The bus stop code to fetch services for.
  final String busStopCode;

  /// Currently selected service number, or null if none selected.
  final String? selectedService;

  /// Called when a service chip is tapped.
  final ValueChanged<String> onServiceTap;

  const ServiceChipsBar({
    super.key,
    required this.busStopCode,
    required this.selectedService,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesAtStopProvider(busStopCode));

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) return const SizedBox.shrink();
        return _ServiceChipsList(
          services: services,
          selectedService: selectedService,
          onServiceTap: onServiceTap,
        );
      },
      loading: () => const SizedBox(
        height: 56,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      // Silently hide on error — arrivals list still works.
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// =============================================================================
// Service Chips List (scrollable row)
// =============================================================================

class _ServiceChipsList extends StatelessWidget {
  final List<ServiceSummary> services;
  final String? selectedService;
  final ValueChanged<String> onServiceTap;

  const _ServiceChipsList({
    required this.services,
    required this.selectedService,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: services.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final svc = services[index];
          final isSelected = svc.serviceNo == selectedService;
          return _ServiceChip(
            service: svc,
            isSelected: isSelected,
            onTap: () => onServiceTap(svc.serviceNo),
          );
        },
      ),
    );
  }
}

// =============================================================================
// Single Service Chip
// =============================================================================

class _ServiceChip extends StatelessWidget {
  final ServiceSummary service;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceChip({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = AppTheme.parseHexColor(service.color);

    return Material(
      color: isSelected ? chipColor.withValues(alpha: 0.2) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? chipColor : Colors.grey.shade400,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Service number badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  service.serviceNo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Destination text
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  service.destination,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // FREE badge
              if (service.isFree) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    'FREE',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
