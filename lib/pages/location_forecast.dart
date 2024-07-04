import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/pages/forecast.dart';
import 'package:weather_app/providers/location_forecast_provider.dart';

class LocationForecast extends ConsumerWidget {
  final double lat;
  final double long;

  const LocationForecast({super.key, required this.lat, required this.long});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastDataValue = ref.watch(locationForecastProvider((lat, long)));
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
      error: (e, __) => Text(e.toString()),
    );
  }
}
