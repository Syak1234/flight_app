import 'core/config/app_config.dart';
import 'main_common.dart';

void main() {
  final devConfig = AppConfig(
    appTitle: '[DEV] Fight App',
    apiBaseUrl: 'https://dev.api.fightapp.com',
    environment: AppEnvironment.dev,
    showDebugBanner: true,
  );

  runMainApp(devConfig);
}
