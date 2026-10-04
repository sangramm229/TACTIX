class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String scenarios = '/scenarios';
  static const String scenarioDetail = '/scenario/:id';
  static const String simulation = '/simulation/:sessionId';
  static const String report = '/report/:sessionId';
  static const String history = '/history';
  static const String profile = '/profile';

  static String scenarioDetailPath(String id) => '/scenario/$id';
  static String simulationPath(String sessionId) => '/simulation/$sessionId';
  static String reportPath(String sessionId) => '/report/$sessionId';
}
