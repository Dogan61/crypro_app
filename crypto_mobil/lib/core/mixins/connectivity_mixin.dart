import 'package:flutter/material.dart';

/// Mixin for handling connectivity/network state
mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  void setOnlineStatus(bool status) {
    if (mounted) {
      setState(() {
        _isOnline = status;
      });
    }
  }

  Widget buildOfflineIndicator() {
    if (_isOnline) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text('No internet connection', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void showNoConnectionSnackBar(BuildContext context) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 8),
            Text('No internet connection'),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
