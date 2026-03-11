import 'core/config/app_config.dart';
import 'main_common.dart';

void main() {
  final stagingConfig = AppConfig(
    appTitle: '[STG] Fight App',
    apiBaseUrl: 'https://staging.api.fightapp.com',
    environment: AppEnvironment.staging,
    showDebugBanner: true,
  );

  runMainApp(stagingConfig);
}
