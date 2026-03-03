/// Arrival tile widget showing a single bus service's ETA info.
///
/// Displays service number (colored), destination, N arrival times
/// (up to [_maxEtaDisplay]), plate numbers, live/scheduled indicator,
/// and debug metadata. Includes a 1-second countdown timer for
/// client-side ETA interpolation between server polls.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';

/// Maximum number of arrivals to display in the ETA column.
const int _maxEtaDisplay = 3;

// =============================================================================
// Arrival Tile (StatefulWidget for countdown timer)
// =============================================================================

class ArrivalTile extends StatefulWidget {
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
  State<ArrivalTile> createState() => _ArrivalTileState();
}

class _ArrivalTileState extends State<ArrivalTile> {
  late final Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arrival = widget.arrival;
    final serviceColor = AppTheme.parseHexColor(arrival.color);
    final theme = Theme.of(context);

    return Card(
      color: widget.isSelected
          ? serviceColor.withValues(alpha: 0.15)
          : theme.cardColor,
      child: InkWell(
        onTap: widget.onTap,
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
// ETA Column (N arrival times, capped at _maxEtaDisplay)
// =============================================================================

class _EtaColumn extends StatelessWidget {
  final BusArrivalInfo arrival;

  const _EtaColumn({required this.arrival});

  @override
  Widget build(BuildContext context) {
    final arrivals = arrival.arrivals;

    if (arrivals.isEmpty) {
      return Text(
        '--',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final displayCount = arrivals.length > _maxEtaDisplay
        ? _maxEtaDisplay
        : arrivals.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < displayCount; i++) ...[
          if (i > 0) const SizedBox(height: 4),
          _EtaDisplay(arrivalTime: arrivals[i], isPrimary: i == 0),
        ],
      ],
    );
  }
}

// =============================================================================
// ETA Display (single arrival time with live/scheduled indicator)
// =============================================================================

class _EtaDisplay extends StatelessWidget {
  final ArrivalTime? arrivalTime;
  final bool isPrimary;

  const _EtaDisplay({required this.arrivalTime, required this.isPrimary});

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
    final isArriving = minutes <= 0;

    final minuteText = isArriving ? 'ARR' : '${minutes}m';
    final color = isLive ? Colors.green : Colors.orange;
    final textStyle = TextStyle(
      color: color,
      fontSize: isPrimary ? 20 : 14,
      fontWeight: FontWeight.bold,
    );

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
            if (isArriving)
              _PulsingText(text: minuteText, style: textStyle)
            else
              Text(minuteText, style: textStyle),
          ],
        ),
        Text(timeStr, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
      ],
    );
  }
}

// =============================================================================
// Pulsing Text (subtle opacity animation for "ARR" indicator)
// =============================================================================

class _PulsingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _PulsingText({required this.text, required this.style});

  @override
  State<_PulsingText> createState() => _PulsingTextState();
}

class _PulsingTextState extends State<_PulsingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(widget.text, style: widget.style),
    );
  }
}
