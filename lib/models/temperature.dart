class Temperature {
  final double celsius;

  Temperature.celsius(this.celsius);

  factory Temperature.fahrenheit(double fahrenheit) =>
      Temperature.celsius((fahrenheit - 32) / 1.8);

  double get fahrenheit => celsius * 1.8 + 32;

  @override
  String toString() {
    return '$celsius°C / ${fahrenheit.toStringAsFixed(1)}°F';
  }
}
