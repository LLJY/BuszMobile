/// Reusable error boundary widget for displaying error states.
///
/// Shows a user-friendly error message with an optional retry button.
/// In debug mode, includes a collapsible section with technical details.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_exception.dart';

// =============================================================================
// Error Boundary
// =============================================================================

/// A presentational widget that displays an error state with:
/// - Error icon
/// - User-friendly message (from [AppException.userMessage] or toString)
/// - Optional retry button
/// - Collapsible debug detail (debug mode only)
class ErrorBoundary extends StatelessWidget {
  /// The error to display. If an [AppException], its [userMessage] is shown.
  final Object error;

  /// Optional callback for the retry button. If null, no button is shown.
  final VoidCallback? onRetry;

  const ErrorBoundary({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final message = error is AppException
        ? (error as AppException).userMessage
        : error.toString();

    final debugDetail = error is AppException
        ? (error as AppException).debugMessage
        : null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
            if (kDebugMode && debugDetail != null) ...[
              const SizedBox(height: 16),
              _CollapsibleDebugDetail(detail: debugDetail),
            ],
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Collapsible Debug Detail (internal)
// =============================================================================

/// A small stateful widget that handles expand/collapse of debug info.
///
/// Only used inside [ErrorBoundary] in debug mode.
class _CollapsibleDebugDetail extends StatefulWidget {
  final String detail;

  const _CollapsibleDebugDetail({required this.detail});

  @override
  State<_CollapsibleDebugDetail> createState() =>
      _CollapsibleDebugDetailState();
}

class _CollapsibleDebugDetailState extends State<_CollapsibleDebugDetail> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              const Text(
                'Debug details',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.detail,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
