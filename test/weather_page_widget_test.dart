import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_info.dart';
import 'package:weather_app/models/weather_params.dart';
import 'package:weather_app/pages/weather_icon_image.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mockito/annotations.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';

@GenerateNiceMocks([MockSpec<HttpWeatherRepository>()])
import 'package:weather_app/repositories/WeatherRepository.dart';
import 'weather_page_widget_test.mocks.dart';

void main() {
  // init mock repo
  late MockHttpWeatherRepository mockRepository;

  // create test data
  final testWeather = Weather(
    weatherParams: WeatherParams(
      temp: 20.0,
      tempMax: 22.0,
      tempMin: 15.0,
      feelsLike: 24.0,
      humidity: 100,
    ),
    wind: Wind(speed: 100, deg: 0),
    weatherInfo: [
      WeatherInfo(main: "Clear", description: "Clear sky", icon: "01d")
    ],
    dt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
  );
  final forecastData = List.generate(36, (int index) => testWeather, growable: false);
  final testForecast = Forecast(list: forecastData);

  setUp(() {
    mockRepository = MockHttpWeatherRepository();

    when(mockRepository.getWeather(city: anyNamed('city')))
        .thenAnswer((_) async => testWeather);

    when(mockRepository.getForecast(city: anyNamed('city')))
        .thenAnswer((_) async => testForecast);
  });

  testWidgets('WeatherPage displays shows loading state',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
      // overide ApiWeatherRepository with mockRepository
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
          home: WeatherPage(
            city: 'Munich',
            onDelete: () {},
          ),
        ),
      ),
    ));
    // Should display loading icon during load state
    expect(find.byType(CircularProgressIndicator), findsExactly(2));
    // finish load state
    await mockNetworkImagesFor(() => tester.pumpAndSettle());
  });

  testWidgets('WeatherPage displays current weather data',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
      // overide ApiWeatherRepository with mockRepository
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
          home: WeatherPage(
            city: 'Munich',
            onDelete: () {},
          ),
        ),
      ),
    ));
    // finish load state
    await mockNetworkImagesFor(() => tester.pumpAndSettle());
    // check for expected weather data
    expect(find.text("MUNICH"), findsOneWidget); // location
    expect(find.text("20°C"), findsOneWidget); // current temp
    expect(find.text("H:22° L:15°"), findsOneWidget); // max / min temp
    expect(find.byType(WeatherIconImage), findsExactly(11)); // should find 11 weather icons: 1 current + 10 forecast (5 hourly + 5 daily)
    expect(find.text("20°"), findsExactly(10)); // should find 10 equal temperature texts for the forecast values 
  });
}
