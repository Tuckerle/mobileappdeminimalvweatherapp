import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/models/forecast.dart' as forecast_model;
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_info.dart';
import 'package:weather_app/models/weather_params.dart';
import 'package:weather_app/pages/forecast.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';
import 'package:weather_app/repositories/WeatherRepository.dart';

import 'city_current_weather_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HttpWeatherRepository>()])
void main() {
  final mockWeatherRepository = MockHttpWeatherRepository();
  final sampleWeather = Weather(
    weatherParams: WeatherParams(
      temp: 20.0,
      tempMax: 22.0,
      tempMin: 15.0,
      feelsLike: 24.0,
      humidity: 100,
    ),
    wind: Wind(speed: 100, deg: 0),
    weatherInfo: List.of(
        {WeatherInfo(main: "Rain", description: "light rain", icon: "10n")}),
    dt: DateTime(2022, 1, 1).millisecondsSinceEpoch,
  );

  List<Weather> sampleWeatherList = List.generate(40, (i) => sampleWeather);
  var sampleForecastData = forecast_model.Forecast(list: sampleWeatherList);

  setUp(() {
    reset(mockWeatherRepository);
    when(mockWeatherRepository.getForecast(city: anyNamed('city')))
        .thenAnswer((_) async => sampleForecastData);
  });

  testWidgets('Forecast widget displays loading state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(mockWeatherRepository),
        ],
        child: const MaterialApp(
          home: Forecast(city: 'city'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('Forecast widget displays data state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(mockWeatherRepository),
        ],
        child: const MaterialApp(
          home: Forecast(city: 'Test City'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text("NEXT HOURS"), findsOneWidget);
    expect(find.text("NEXT DAYS"), findsOneWidget);
  });
}
