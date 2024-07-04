import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/pages/current_weather.dart';
import 'package:weather_app/providers/location_current_weather_provider.dart';

class LocationCurrentWeather extends ConsumerWidget {
  final double lat;
  final double long;
  const LocationCurrentWeather( {super.key, required this.lat, required this.long});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherDataValue = ref.watch(locationCurrentWeatherProvider((lat, long)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("CURRENT LOCATION", style: Theme.of(context).textTheme.headlineMedium),
        weatherDataValue.when(
          data: (weatherData) => CurrentWeatherContents(data: weatherData),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, __) => Text(e.toString()),
        ),
      ],
    );
  }
}