class Config {
  static final Config _instance = Config._internal();

  factory Config() => _instance;

  Config._internal();

  final String baseUrl = "http://backend-bootcamp.localhost/api";
}