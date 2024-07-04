import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/theme/theme_switcher.dart';

void main() {
  runApp(ProviderScope(
    child: ThemeSwitcherWidget(
      initialTheme: initialThemeData,
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeSwitcher.of(context).themeData,
      home: const WeatherPageView(initialCities: [
        'LONDON',
        'PARIS',
        'NEW YORK',
        'HAMBURG',
        'MUNICH',
        'AUGSBURG',
        'BERLIN',
        'LEONBERG',
        'ISTANBUL',
        'MADRID'
      ]),
    );
  }
}
