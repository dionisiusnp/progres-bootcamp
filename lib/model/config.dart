class Config {
  static final Config _instance = Config._internal();

  factory Config() => _instance;

  Config._internal();

  final String baseUrl = "https://b506-202-51-113-148.ngrok-free.app/api";
}