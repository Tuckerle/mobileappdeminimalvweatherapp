import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/pages/current_weather.dart';
import 'package:weather_app/pages/detailed_forecast.dart';
import 'package:weather_app/pages/location_current_weather.dart';
import 'package:weather_app/pages/location_forecast.dart';
import 'package:weather_app/pages/settings.dart';
import 'package:weather_app/providers/position_provider.dart';
import 'city_grid_view.dart';
import 'forecast.dart';

class WeatherPageView extends StatefulWidget {
  final List<String> initialCities;

  const WeatherPageView({super.key, required this.initialCities});

  @override
  State<WeatherPageView> createState() => _WeatherPageViewState();
}

class _WeatherPageViewState extends State<WeatherPageView> {
  late PageController _pageController;
  int _currentPage = 0;
  late List<String> _cities;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _cities = List.from(widget.initialCities);
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  void _addCity(String city) {
    setState(() {
      if (!_cities.contains(city.toUpperCase())) {
        _cities.add(city.toUpperCase());
        // animate to newly created page on last index
        _pageController.animateToPage(
          _cities.length,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _pageController.animateToPage(
          _cities.indexOf(city.toUpperCase()) + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _deleteCity(int index) {
    setState(() {
      _cities.removeAt(index - 1);
      if (_pageController.hasClients) {
        // animate to closest existing page
        int next = _cities.isNotEmpty ? (index).clamp(0, _cities.length) : 1;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _openGridView() async {
    final selectedCity = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => CityGridView(cities: _cities),
      ),
    );

    if (selectedCity != null && _cities.contains(selectedCity)) {
      final index = _cities.indexOf(selectedCity);
      _pageController.jumpToPage(index + 1);
    }
  }

  void _openSettings() async {
    final selectedCity = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );

    if (selectedCity != null && _cities.contains(selectedCity)) {
      final index = _cities.indexOf(selectedCity);
      _pageController.jumpToPage(index + 1);
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.settings,
                color: Theme.of(context).primaryColor, size: 25),
            onPressed: _openSettings,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: _isSearching ? _buildSearchField() : const Text(''),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search,
                  color: Theme.of(context).primaryColor, size: 25),
              onPressed: _toggleSearch,
            ),
            IconButton(
              icon: Icon(Icons.grid_view,
                  color: Theme.of(context).primaryColor, size: 25),
              onPressed: _openGridView,
            ),
          ],
        ),
        body: Stack(children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _cities.length + 1,
            itemBuilder: (context, index) {
              // First Page is always current Location
              return index == 0
                  ? const LocationWeatherPage(
                      key: ValueKey(-1), // Ensure each page has a unique key
                    )
                  : WeatherPage(
                      key: ValueKey(_cities[
                          index - 1]), // Ensure each page has a unique key
                      city: _cities[index - 1],
                      onDelete: () => _deleteCity(index),
                    );
            },
          ),
          Positioned(
              top: 10.0,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                    controller: _pageController,
                    count: _cities.length + 1,
                    effect: SlideEffect(
                      dotWidth: 8.0,
                      dotHeight: 8.0,
                      activeDotColor: Theme.of(context).primaryColor,
                    )),
              ))
        ])
        // : Scaffold(
        //     body: Center(
        //       child: Text(
        //         'Add a Location via the search bar',
        //         style: Theme.of(context).textTheme.headlineMedium,
        //       ),
        //     ),
        //   ),
        );
  }

  Widget _buildSearchField() {
    final TextEditingController controller = TextEditingController();
    return TextField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Add a City',
        hintStyle: TextStyle(color: Theme.of(context).primaryColor),
        border: InputBorder.none,
        hintMaxLines: 1,
      ),
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
      onSubmitted: (query) {
        _toggleSearch();
        if (query.isNotEmpty) {
          _addCity(query);
        }
      },
    );
  }
}

class WeatherPage extends StatelessWidget {
  final String city;
  final VoidCallback onDelete;

  const WeatherPage({super.key, required this.city, required this.onDelete});

  void _showDetailedForecastView(BuildContext context, String city) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DetailedForecastView(city: city);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                CurrentWeather(city: city, onDelete: onDelete),
                const SizedBox(height: 40),
                Forecast(city: city),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.info,
                          color: Theme.of(context).primaryColor,
                          size: 30),
                      onPressed: () =>
                          _showDetailedForecastView(context, city),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.delete,
                          color: Theme.of(context).primaryColor,
                          size: 30),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: SizedBox.shrink(), // Placeholder for spacing
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocationWeatherPage extends ConsumerWidget {
  const LocationWeatherPage({
    super.key,
  });

  void _showDetailedForecastView(
      BuildContext context, double lat, double long) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocationDetailedForecastView(lat: lat, long: long);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationDataValue = ref.watch(positionProvider);
    return locationDataValue.when(
      data: (locationData) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    LocationCurrentWeather(
                        lat: locationData.latitude,
                        long: locationData.longitude),
                    const SizedBox(height: 40),
                    LocationForecast(
                        lat: locationData.latitude,
                        long: locationData.longitude),
                    const SizedBox(height: 40),
                    IconButton(
                      icon: Icon(Icons.info,
                          color: Theme.of(context).primaryColor, size: 30),
                      onPressed: () => _showDetailedForecastView(context,
                          locationData.latitude, locationData.longitude),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}
