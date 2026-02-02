import 'package:flutter/material.dart';

/// Mixin for handling error states in widgets
mixin ErrorHandlerMixin<T extends StatefulWidget> on State<T> {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setError(String? message) {
    if (mounted) {
      setState(() {
        _errorMessage = message;
      });
    }
  }

  void clearError() {
    if (mounted) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  Widget buildErrorWidget({
    String? message,
    VoidCallback? onRetry,
    String retryButtonText = 'Retry',
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message ?? _errorMessage ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
