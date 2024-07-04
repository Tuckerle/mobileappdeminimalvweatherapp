class WeatherParams {
  WeatherParams({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
    required this.humidity,
  });

  factory WeatherParams.fromJson(Map<String, dynamic> json) => WeatherParams(
    temp: (json["temp"] as num).toDouble(),
    tempMin: (json["temp_min"] as num).toDouble(),
    tempMax: (json["temp_max"] as num).toDouble(),
    feelsLike: (json["feels_like"] as num).toDouble(),
    humidity: json["humidity"],
  );

  final double temp;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final int humidity;
}

class Wind {
  final double speed;
  final int deg;

  Wind({
    required this.speed,
    required this.deg,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
    speed: (json["speed"] as num).toDouble(),
    deg: json["deg"],
  );
}