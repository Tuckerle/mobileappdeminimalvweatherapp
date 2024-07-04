class WeatherInfo {
  WeatherInfo({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) =>
      WeatherInfo(
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
      );

  final String main;
  final String description;
  final String icon;
}