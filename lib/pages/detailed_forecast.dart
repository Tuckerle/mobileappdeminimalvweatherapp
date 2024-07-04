import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/forecast_data.dart';
import 'package:weather_app/pages/weather_icon_image.dart';
import 'package:weather_app/providers/city_forecast_provider.dart';
import 'package:weather_app/providers/location_forecast_provider.dart';

class DetailedForecastView extends StatelessWidget {
  final String city;

  const DetailedForecastView({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, WidgetRef ref, _) {
        final forecastData = ref.watch(cityForecastProvider(city));
        return forecastData.when(
          data: (forecastData) {
            return DetailedForecast(forecastData: forecastData);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, __) => Text('Error: ${e.toString()}'),
        );
      },
    );
  }
}

class LocationDetailedForecastView extends StatelessWidget {
  final double lat;
  final double long;

  const LocationDetailedForecastView(
      {super.key, required this.lat, required this.long});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, WidgetRef ref, _) {
        final forecastData = ref.watch(locationForecastProvider((lat, long)));
        return forecastData.when(
          data: (forecastData) {
            return DetailedForecast(forecastData: forecastData);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, __) => Text('Error: ${e.toString()}'),
        );
      },
    );
  }
}

class DetailedForecast extends StatelessWidget {
  final ForecastData forecastData;
  const DetailedForecast({
    super.key,
    required this.forecastData,
  });

  String degreesToCardinal(int degrees) {
        final cardinals = List.from({ "NORTH", "NORTH-EAST", "EAST", "SOUTH-EAST", "SOUTH", "SOUTH-WEST", "WEST", "NORTH-WEST", "NORTH" });
        return cardinals[((degrees % 360) / 45).round()];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text('Detailed Forecast'.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: min(forecastData.list.length, 9),
          itemBuilder: (context, index) {
            final data = forecastData.list[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateFormat('EEEE, MMM d, hh:mm a')
                              .format(data.date)
                              .toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium),
                      WeatherIconImage(iconUrl: data.iconUrl, size: 48),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Average Temperature:'.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                      Text('${data.temp.celsius.toStringAsFixed(1)}°C'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Min Temperature:'.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                      Text('${data.minTemp.celsius.toStringAsFixed(1)}°C'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Max Temperature:'.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                      Text('${data.maxTemp.celsius.toStringAsFixed(1)}°C'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Feels Like:'.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                      Text('${data.feelsLike.celsius.toStringAsFixed(1)}°C'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Humidity:'.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                      Text('${data.humidity}%'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Wind Speed:'.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                      Text('${data.wind.speed} m/s'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Wind Direction:'.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                      Text(degreesToCardinal(data.wind.deg)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
