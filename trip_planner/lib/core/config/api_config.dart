class ApiConfig {
  const ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static String assetUrl(String path) {
    if (path.isEmpty) return path;
    final uri = Uri.tryParse(path);
    if (uri?.hasScheme == true) return path;

    final base = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/');
    return base.resolve(path.startsWith('/') ? path.substring(1) : path).toString();
  }
}
