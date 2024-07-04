import 'package:flutter/material.dart';
import 'package:weather_app/pages/simple_current_weather.dart';

class CityGridView extends StatelessWidget {
  final List<String> cities;

  const CityGridView({super.key, required this.cities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'.toUpperCase(),style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child:  GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: cities.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(cities[index]);
              },
              child: GridTile(
                child: Card.filled(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SimpleCurrentWeather(city: cities[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
