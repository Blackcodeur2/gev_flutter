import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/config/theme_config.dart';
import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.themeClair,
      darkTheme: AppTheme.themeSombre,
      themeMode: themeProvider.themeMode,
      routerConfig: AppRouter.router,
    );
  }
}