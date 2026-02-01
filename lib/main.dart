import 'package:crypto_app/core/theme/app_theme.dart';
import 'package:crypto_app/feature/settings/settings_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: const SettingsView(),
    );
  }
}
