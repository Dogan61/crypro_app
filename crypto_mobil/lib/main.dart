import 'package:crypto_mobil/core/constants/text_const.dart';
import 'package:crypto_mobil/core/di/injection.dart';
import 'package:crypto_mobil/core/router/app_router.dart';
import 'package:crypto_mobil/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: TextConst.appName,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
