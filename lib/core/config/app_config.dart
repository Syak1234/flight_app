enum AppEnvironment { dev, staging, prod }

class AppConfig {
  final String appTitle;
  final String apiBaseUrl;
  final AppEnvironment environment;
  final bool showDebugBanner;

  AppConfig({
    required this.appTitle,
    required this.apiBaseUrl,
    required this.environment,
    this.showDebugBanner = false,
  });

  static late AppConfig _instance;
  static AppConfig get instance => _instance;

  static void setConfig(AppConfig config) {
    _instance = config;
  }
}
