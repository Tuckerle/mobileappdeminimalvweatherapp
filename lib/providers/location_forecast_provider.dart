import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/forecast_data.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';

final locationForecastProvider = FutureProvider.family.autoDispose<ForecastData, (double, double)>((ref, coords) async {
  final forecast = await ref.watch(weatherRepositoryProvider).getForecastCoord(lat: coords.$1, long: coords.$2);
  return ForecastData.from(forecast);
});