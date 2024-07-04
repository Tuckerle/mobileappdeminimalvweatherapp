import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/pages/weather_icon_image.dart';
import 'package:weather_app/providers/city_current_weather_provider.dart';

class CurrentWeather extends ConsumerWidget {
  final String city;
  final VoidCallback onDelete;
  const CurrentWeather({super.key, required this.city, required this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherDataValue = ref.watch(cityCurrentWeatherProvider(city));
    return weatherDataValue.when(
      data: (weatherData) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(city.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium),
          CurrentWeatherContents(data: weatherData)
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) {
        // Show the dialog when there's an error
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => onDelete());
        return const SizedBox.shrink();
      },
    );
  }
}

class CurrentWeatherContents extends ConsumerWidget {
  const CurrentWeatherContents({super.key, required this.data});
  final WeatherData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.temp.celsius.toInt().toString();
    final minTemp = data.minTemp.celsius.toInt().toString();
    final maxTemp = data.maxTemp.celsius.toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: data.iconUrl, size: 120),
        Text("$temp°C", style: textTheme.displayMedium),
        Text(highAndLow, style: textTheme.bodyMedium),
      ],
    );
  }
}