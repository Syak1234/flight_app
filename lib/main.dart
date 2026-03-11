import 'package:flight_app/core/constants/app_strings.dart';

import 'core/config/app_config.dart';
import 'main_common.dart';

void main() {
  final prodConfig = AppConfig(
    appTitle: AppStrings.appName,
    apiBaseUrl: 'https://api.fightapp.com',
    environment: AppEnvironment.dev,
    showDebugBanner: false,
  );

  runMainApp(prodConfig);
}
