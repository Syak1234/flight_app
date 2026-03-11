import 'core/config/app_config.dart';
import 'main_common.dart';

void main() {
  final prodConfig = AppConfig(
    appTitle: 'Fight App',
    apiBaseUrl: 'https://api.fightapp.com',
    environment: AppEnvironment.dev,
    showDebugBanner: false,
  );

  runMainApp(prodConfig);
}
