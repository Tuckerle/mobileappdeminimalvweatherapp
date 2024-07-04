import 'package:weather_app/models/temperature.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_params.dart';

class WeatherData {
  WeatherData({
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.feelsLike,
    required this.humidity,
    required this.wind,
    required this.description,
    required this.date,
    required this.icon,
  });

  factory WeatherData.from(Weather weather) {
    return WeatherData(
      temp: Temperature.celsius(weather.weatherParams.temp),
      minTemp: Temperature.celsius(weather.weatherParams.tempMin),
      maxTemp: Temperature.celsius(weather.weatherParams.tempMax),
      feelsLike: Temperature.celsius(weather.weatherParams.feelsLike),
      humidity: weather.weatherParams.humidity,
      wind: weather.wind,
      description: weather.weatherInfo[0].main,
      date: DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000),
      icon: weather.weatherInfo[0].icon,
    );
  }

  final Temperature temp;
  final Temperature minTemp;
  final Temperature maxTemp;
  final Temperature feelsLike;
  final int humidity;
  final Wind wind;
  final String description;
  final DateTime date;
  final String icon;

  String get iconUrl => "https://openweathermap.org/img/wn/$icon@2x.png";
}