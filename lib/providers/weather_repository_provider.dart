import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/api.dart';
import 'package:weather_app/api/api_key.dart';
import 'package:weather_app/repositories/WeatherRepository.dart';

/// Providers used by rest of the app
final weatherRepositoryProvider = Provider<HttpWeatherRepository>((ref) {
  /// Use the API key passed via --dart-define,
  /// or fallback to the one defined in api_keys.dart
  // set key to const
  const apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: APIKey.openWeatherAPIKey,
  );
  return HttpWeatherRepository(
    api: OpenWeatherMapAPI(apiKey),
    client: http.Client(),
  );
});