import 'dart:async';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/connectivity_provider.dart';
import 'core/widgets/connectivity_wrapper.dart';
import 'core/widgets/error_screen.dart';
import 'core/config/app_config.dart';

void runMainApp(AppConfig config) {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      AppConfig.setConfig(config);

      FlutterError.onError = (FlutterErrorDetails details) {
        if (kDebugMode) {
          FlutterError.presentError(details);
        }
      };

      ErrorWidget.builder = (FlutterErrorDetails details) =>
          const GlobalErrorScreen();

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      runApp(
        DevicePreview(
          enabled: true,
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
            ],
            child: const FlightApp(),
          ),
        ),
      );
    },
    (error, stack) {
      if (kDebugMode) {
        debugPrint('Async Error: $error');
      }
    },
  );
}

class FlightApp extends StatelessWidget {
  const FlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    return MaterialApp.router(
      title: config.appTitle,
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return ConnectivityWrapper(child: child!);
      },
    );
  }
}
