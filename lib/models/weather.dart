import 'package:weather_app/models/weather_info.dart';
import 'package:weather_app/models/weather_params.dart';

class Weather {
  Weather({
    required this.weatherParams,
    required this.weatherInfo,
    required this.wind,
    required this.dt,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    weatherParams: WeatherParams.fromJson(json["main"]),
    weatherInfo: List<WeatherInfo>.from(json["weather"].map((x) => WeatherInfo.fromJson(x))),
    wind: Wind.fromJson(json["wind"]),
    dt: json["dt"],
  );

  final WeatherParams weatherParams;
  final List<WeatherInfo> weatherInfo;
  final Wind wind;
  final int dt;
}