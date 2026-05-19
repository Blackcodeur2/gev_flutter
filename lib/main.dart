import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/config/theme_config.dart';
import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:camer_trip/app/services/api_client_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:camer_trip/app/config/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();

  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.themeClair,
      darkTheme: AppTheme.themeSombre,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      routerConfig: AppRouter.router,
    );
  }
}