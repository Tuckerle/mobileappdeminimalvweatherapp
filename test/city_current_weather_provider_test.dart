import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/models/temperature.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_info.dart';
import 'package:weather_app/models/weather_params.dart';
import 'package:weather_app/providers/city_current_weather_provider.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';
import 'package:weather_app/repositories/WeatherRepository.dart';

import 'city_current_weather_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HttpWeatherRepository>()])
void main() {
  final mockWeatherRepository = MockHttpWeatherRepository();

  final testWeatherData = WeatherData(
    temp: Temperature.celsius(25.0),
    date: DateTime(2022, 1, 1),
    maxTemp: Temperature.celsius(26.0),
    minTemp: Temperature.celsius(24.0),
    feelsLike: Temperature.celsius(24.0),
    humidity: 100,
    wind: Wind(speed: 100, deg: 0),
    icon: '10n',
    description: 'Rain',
  );

  //create a dummy weather using the correct constructor
  final testWeather = Weather(
      weatherParams: WeatherParams(
        temp: 25.0,
        tempMax: 26.0,
        tempMin: 24.0,
        feelsLike: 24.0,
        humidity: 100,
      ),
      wind: Wind(speed: 100, deg: 0),
      weatherInfo: [
        WeatherInfo(main: 'Rain', description: 'light rain', icon: '10n')
      ],
      dt: 1640995200 - 3600);

  when(mockWeatherRepository.getWeather(city: anyNamed('city')))
      .thenAnswer((_) async => testWeather);

  final container = ProviderContainer(
    overrides: [
      weatherRepositoryProvider.overrideWithValue(mockWeatherRepository),
    ],
  );

  tearDown(() {
    container.dispose();
  });

  test('cityCurrentWeatherProvider returns weather data for a given city',
      () async {
    final result =
        await container.read(cityCurrentWeatherProvider('city').future);
    expect(result.temp.celsius, equals(testWeatherData.temp.celsius));
    expect(result.date, equals(testWeatherData.date));
    expect(result.maxTemp.celsius, equals(testWeatherData.maxTemp.celsius));
    expect(result.minTemp.celsius, equals(testWeatherData.minTemp.celsius));
    expect(result.feelsLike.celsius, equals(testWeatherData.feelsLike.celsius));
    expect(result.humidity, equals(testWeatherData.humidity));
    expect(result.wind.deg, equals(testWeatherData.wind.deg));
    expect(result.wind.speed, equals(testWeatherData.wind.speed));
    expect(result.icon, equals(testWeatherData.icon));
    expect(result.description, equals(testWeatherData.description));
  });
}
