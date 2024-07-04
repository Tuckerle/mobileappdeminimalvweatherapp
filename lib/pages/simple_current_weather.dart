import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/pages/weather_icon_image.dart';
import 'package:weather_app/providers/city_current_weather_provider.dart';

class SimpleCurrentWeather extends ConsumerWidget {
  final String city;
  const SimpleCurrentWeather({super.key, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherDataValue = ref.watch(cityCurrentWeatherProvider(city));
    return weatherDataValue.when(
      data: (weatherData) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(city.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium),
          SimpleCurrentWeatherContents(data: weatherData)
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => const SizedBox.shrink(),
    );
  }
}

class SimpleCurrentWeatherContents extends StatelessWidget {
  const SimpleCurrentWeatherContents({super.key, required this.data});
  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.temp.celsius.toInt().toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: data.iconUrl, size: 100),
        Text('$temp°C', style: textTheme.headlineMedium),
      ],
    );
  }
}
