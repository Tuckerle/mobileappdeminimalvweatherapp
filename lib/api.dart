class OpenWeatherMapAPI {
  OpenWeatherMapAPI(this.apiKey);
  final String apiKey;

  static const String _apiBaseUrl = "api.openweathermap.org";
  static const String _apiPath = "/data/2.5/";

  Uri weather(String city) => _buildUri(
    endpoint: "weather",
    parametersBuilder: () => cityQueryParameters(city),
  );

  Uri weatherCoord(double lat, double long) => _buildUri(
    endpoint: "weather",
    parametersBuilder: () => coordQueryParameters(lat, long),
  );

  Uri forecast(String city) => _buildUri(
    endpoint: "forecast",
    parametersBuilder: () => cityQueryParameters(city),
  );

  Uri forecastCoord(double lat, double long) => _buildUri(
    endpoint: "forecast",
    parametersBuilder: () => coordQueryParameters(lat, long),
  );

  Uri _buildUri({
    required String endpoint,
    required Map<String, dynamic> Function() parametersBuilder,
  }) {
    return Uri(
      scheme: "https",
      host: _apiBaseUrl,
      path: "$_apiPath$endpoint",
      queryParameters: parametersBuilder(),
    );
  }

  Map<String, dynamic> cityQueryParameters(String city) => {
    "q": city,
    "appid": apiKey,
    "units": "metric",
      };

  Map<String, dynamic> coordQueryParameters(double lat, double long) => {
    "lat": lat.toString(),
    "lon": long.toString(),
    "appid": apiKey,
    "units": "metric",
      };
}