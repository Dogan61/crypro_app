import 'dart:async';

import 'package:flutter/material.dart';

/// Mixin for debouncing user actions (e.g., search input)
mixin DebounceMixin<T extends StatefulWidget> on State<T> {
  Timer? _debounceTimer;
  
  Duration get debounceDuration => const Duration(milliseconds: 500);

  void debounce(VoidCallback action, {Duration? duration}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      duration ?? debounceDuration,
      action,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
