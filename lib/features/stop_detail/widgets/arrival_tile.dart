/// Arrival tile widget showing a single bus service's ETA info.
///
/// Displays service number (colored), destination, 2 arrival times
/// (Next and Later), plate numbers, live/scheduled indicator,
/// and debug metadata. Includes a 1-second countdown timer for
/// client-side ETA interpolation between server polls.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: widget.isSelected
          ? serviceColor.withValues(alpha: 0.15)
          : colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            children: [
              // Service number badge
              _ServiceBadge(serviceNo: arrival.serviceNo, color: serviceColor),
              const SizedBox(width: AppSpacing.m),

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
    // M3 API: Estimate the brightness of the color to choose the best
    // contrasting text color (guaranteed legible).
    final isDark =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

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
        style: TextStyle(
          color: textColor,
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
    final colorScheme = Theme.of(context).colorScheme;
    final parts = <Widget>[];

    // Plate number
    if (arrival.plateNo.isNotEmpty) {
      parts.add(_tag(arrival.plateNo, colorScheme.onSurfaceVariant));
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
        _ => colorScheme.onSurfaceVariant,
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
// ETA Column (Next and Later arrival times)
// =============================================================================

class _EtaColumn extends StatelessWidget {
  final BusArrivalInfo arrival;

  const _EtaColumn({required this.arrival});

  @override
  Widget build(BuildContext context) {
    final arrivals = arrival.arrivals;
    final colorScheme = Theme.of(context).colorScheme;

    if (arrivals.isEmpty) {
      return SizedBox(
        width: 92,
        child: Center(
          child: Text(
            '--',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Next Arrival
          _EtaDisplay(arrivalTime: arrivals[0], isPrimary: true),

          if (arrivals.length > 1) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            // Later Arrival
            _EtaDisplay(arrivalTime: arrivals[1], isPrimary: false),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// ETA Display (single arrival time with smart relative/absolute logic)
// =============================================================================

class _EtaDisplay extends StatelessWidget {
  final ArrivalTime? arrivalTime;
  final bool isPrimary;

  const _EtaDisplay({required this.arrivalTime, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    if (arrivalTime == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final diff = arrivalTime!.time.difference(now);
    final minutes = diff.inMinutes;
    final isLive = arrivalTime!.isLive;
    final isArriving = minutes <= 0;

    // Use relative "Nm" if < 60 mins, otherwise show absolute "HH:mm"
    final String displayText;
    if (isArriving) {
      displayText = 'ARR';
    } else if (minutes < 60) {
      displayText = '${minutes}m';
    } else {
      displayText = DateFormat.Hm().format(arrivalTime!.time);
    }

    // Color: Green for live, Orange for scheduled
    final Color baseColor = isLive ? Colors.green : Colors.orange;

    // Emphasis: Primary is bright and bold, Secondary is dimmed and slightly smaller
    final Color displayColor = isPrimary
        ? baseColor
        : baseColor.withValues(alpha: 0.7);

    final double fontSize = isPrimary ? 24 : 16;
    final FontWeight fontWeight = isPrimary ? FontWeight.w900 : FontWeight.w600;

    final textStyle = TextStyle(
      color: displayColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: -0.5,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isLive)
          Icon(Icons.gps_fixed, size: isPrimary ? 12 : 9, color: displayColor)
        else
          Icon(Icons.schedule, size: isPrimary ? 12 : 9, color: displayColor),
        const SizedBox(width: 2),
        if (isArriving && isPrimary)
          _PulsingText(text: displayText, style: textStyle)
        else
          Text(displayText, style: textStyle),
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
