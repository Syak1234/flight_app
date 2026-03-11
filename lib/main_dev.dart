import 'package:flight_app/core/constants/app_strings.dart';

import 'core/config/app_config.dart';
import 'main_common.dart';

void main() {
  final devConfig = AppConfig(
    appTitle: AppStrings.appName,
    apiBaseUrl: 'https://dev.api.fightapp.com',
    environment: AppEnvironment.dev,
    showDebugBanner: true,
  );

  runMainApp(devConfig);
}
