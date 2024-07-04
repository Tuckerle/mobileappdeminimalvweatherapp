import 'package:weather_app/models/weather.dart';

class Forecast {
  Forecast({
    required this.list,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) =>
      Forecast(
        list: List<Weather>.from(json["list"].map((x) => Weather.fromJson(x))),
      );

  final List<Weather> list;
}