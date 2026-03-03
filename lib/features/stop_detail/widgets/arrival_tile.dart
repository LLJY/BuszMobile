/// Arrival tile widget showing a single bus service's ETA info.
///
/// Displays service number (colored), destination, next/later arrival
/// times, plate numbers, live/scheduled indicator, and debug metadata.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';

// =============================================================================
// Arrival Tile
// =============================================================================

class ArrivalTile extends StatelessWidget {
  final BusArrivalInfo arrival;
  final bool isSelected;
  final VoidCallback? onTap;

  const ArrivalTile({
    super.key,
    required this.arrival,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final serviceColor = AppTheme.parseHexColor(arrival.color);
    final theme = Theme.of(context);

    return Card(
      color: isSelected
          ? serviceColor.withValues(alpha: 0.15)
          : theme.cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Service number badge
              _ServiceBadge(serviceNo: arrival.serviceNo, color: serviceColor),
              const SizedBox(width: 12),

              // Destination + metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      arrival.destination,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _MetadataRow(arrival: arrival),
                  ],
                ),
              ),

              // ETA column
              _EtaColumn(arrival: arrival),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Service Badge
// =============================================================================

class _ServiceBadge extends StatelessWidget {
  final String serviceNo;
  final Color color;

  const _ServiceBadge({required this.serviceNo, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        serviceNo,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

// =============================================================================
// Metadata Row (plate no, source, delay)
// =============================================================================

class _MetadataRow extends StatelessWidget {
  final BusArrivalInfo arrival;

  const _MetadataRow({required this.arrival});

  @override
  Widget build(BuildContext context) {
    final parts = <Widget>[];

    // Plate number
    if (arrival.plateNo.isNotEmpty) {
      parts.add(_tag(arrival.plateNo, Colors.grey));
    }

    // ETA source
    final sourceLabel = switch (arrival.etaSource) {
      'ETA_SOURCE_REALTIME' => 'RT',
      'ETA_SOURCE_ML' => 'ML',
      'ETA_SOURCE_SCHEDULED' => 'SCHED',
      _ => '',
    };
    if (sourceLabel.isNotEmpty) {
      final sourceColor = switch (arrival.etaSource) {
        'ETA_SOURCE_REALTIME' => Colors.green,
        'ETA_SOURCE_ML' => Colors.purple,
        _ => Colors.orange,
      };
      parts.add(_tag(sourceLabel, sourceColor));
    }

    // Delay status
    final delayLabel = switch (arrival.delayStatus) {
      'DELAY_STATUS_ON_TIME' => 'ON TIME',
      'DELAY_STATUS_SLIGHT_DELAY' => 'LATE +${arrival.delayMinutes}m',
      'DELAY_STATUS_HEAVY_DELAY' => 'HEAVY +${arrival.delayMinutes}m',
      _ => '',
    };
    if (delayLabel.isNotEmpty) {
      final delayColor = switch (arrival.delayStatus) {
        'DELAY_STATUS_ON_TIME' => Colors.green,
        'DELAY_STATUS_SLIGHT_DELAY' => Colors.orange,
        'DELAY_STATUS_HEAVY_DELAY' => Colors.red,
        _ => Colors.grey,
      };
      parts.add(_tag(delayLabel, delayColor));
    }

    // Departing flag
    if (arrival.isDeparting) {
      parts.add(_tag('DEPARTING', Colors.blue));
    }

    // Free bus
    if (arrival.isFree) {
      parts.add(_tag('FREE', Colors.teal));
    }

    if (parts.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 4, runSpacing: 4, children: parts);
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

// =============================================================================
// ETA Column (next + later arrival times)
// =============================================================================

class _EtaColumn extends StatelessWidget {
  final BusArrivalInfo arrival;

  const _EtaColumn({required this.arrival});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _EtaDisplay(
          arrivalTime: arrival.nextArrival,
          plateNo: arrival.plateNo,
          isPrimary: true,
        ),
        if (arrival.laterArrival != null) ...[
          const SizedBox(height: 4),
          _EtaDisplay(
            arrivalTime: arrival.laterArrival,
            plateNo: arrival.laterPlateNo,
            isPrimary: false,
          ),
        ],
      ],
    );
  }
}

class _EtaDisplay extends StatelessWidget {
  final ArrivalTime? arrivalTime;
  final String plateNo;
  final bool isPrimary;

  const _EtaDisplay({
    required this.arrivalTime,
    required this.plateNo,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    if (arrivalTime == null) {
      return Text(
        '--',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: isPrimary ? 20 : 14,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final minutes = arrivalTime!.time.difference(DateTime.now()).inMinutes;
    final timeStr = DateFormat.Hm().format(arrivalTime!.time);
    final isLive = arrivalTime!.isLive;

    final minuteText = minutes <= 0 ? 'ARR' : '${minutes}m';
    final color = isLive ? Colors.green : Colors.orange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLive)
              Icon(Icons.gps_fixed, size: 10, color: color)
            else
              Icon(Icons.schedule, size: 10, color: color),
            const SizedBox(width: 3),
            Text(
              minuteText,
              style: TextStyle(
                color: color,
                fontSize: isPrimary ? 20 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(timeStr, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
      ],
    );
  }
}
