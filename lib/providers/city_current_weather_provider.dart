import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';

final cityCurrentWeatherProvider = FutureProvider.family<WeatherData, String>((ref, city) async {
  final weatherRepository = ref.watch(weatherRepositoryProvider);
  final weather = await weatherRepository.getWeather(city: city);
  return WeatherData.from(weather);
});