import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/pages/weather_icon_image.dart';
import 'package:weather_app/providers/city_forecast_provider.dart';

class Forecast extends ConsumerWidget {
  final String city;

  const Forecast({super.key, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastDataValue = ref.watch(cityForecastProvider(city));
    return forecastDataValue.when(
      data: (forecastData) {
        final itemsHourly = [0, 1, 2, 3, 4];
        // API returns data points in 3-hour intervals -> 1 day = 8 intervals
        final itemsDaily = [0, 8, 16, 24, 32];
        return Column(
          children: [
            Text("NEXT HOURS", style: Theme.of(context).textTheme.headlineSmall,),
            const SizedBox(height: 25),
            ForecastRow(
              daily: false,
              weatherDataItems: [
                for (var i in itemsHourly) forecastData.list[i],
              ],
            ),
            const SizedBox(height: 60),
            Text("NEXT DAYS", style: Theme.of(context).textTheme.headlineSmall,),
            const SizedBox(height: 25),
            ForecastRow(
              daily: true,
              weatherDataItems: [
                for (var i in itemsDaily) forecastData.list[i],
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => const SizedBox.shrink(),
    );
  }
}

class ForecastRow extends StatelessWidget {
  final bool daily;
  const ForecastRow(
      {super.key, required this.weatherDataItems, required this.daily});
  final List<WeatherData> weatherDataItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: weatherDataItems
          .map((data) => ForecastItem(data: data, daily: daily))
          .toList(),
    );
  }
}

class ForecastItem extends StatelessWidget {
  final bool daily;
  const ForecastItem({super.key, required this.data, required this.daily});
  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const fontWeight = FontWeight.normal;
    final temp = data.temp.celsius.toInt().toString();
    return Expanded(
      child: Column(
        children: [
          Text(
            daily
                ? DateFormat.E().format(data.date)
                : DateFormat.Hm().format(data.date),
            style: textTheme.bodySmall!.copyWith(fontWeight: fontWeight),
          ),
          const SizedBox(height: 8),
          WeatherIconImage(iconUrl: data.iconUrl, size: 48),
          const SizedBox(height: 8),
          Text(
            '$temp°',
            style: textTheme.bodyLarge!.copyWith(fontWeight: fontWeight),
          ),
        ],
      ),
    );
  }
}
