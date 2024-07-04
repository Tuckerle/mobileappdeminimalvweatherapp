import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/forecast_data.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';

final cityForecastProvider = FutureProvider.family.autoDispose<ForecastData, String>((ref, city) async {
  final forecast = await ref.watch(weatherRepositoryProvider).getForecast(city: city);
  return ForecastData.from(forecast);
});