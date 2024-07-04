import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';

final locationCurrentWeatherProvider = FutureProvider.family<WeatherData, (double, double)>((ref, coords) async {
  final weatherRepository = ref.watch(weatherRepositoryProvider);
  final weather = await weatherRepository.getWeatherCoord(lat: coords.$1, long: coords.$2);
  return WeatherData.from(weather);
});