import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final List<String> _cities = [
    'Warsaw',
    'Krakow',
    'Lodz',
    'Wroclaw',
    'Poznan'
  ];
  final Map<String, String?> _weatherData = {};

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    for (final city in _cities) {
      try {
        final data = await _weatherService.fetchWeather(city);
        setState(() {
          _weatherData[city] =
              "${data['main']['temp']}°C, ${data['weather'][0]['description']}";
        });
      } catch (e) {
        setState(() {
          _weatherData[city] = "Error connecting to API: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather in Polish Cities')),
      body: ListView.builder(
        itemCount: _cities.length,
        itemBuilder: (context, index) {
          final city = _cities[index];
          final weather = _weatherData[city] ?? 'Loading...';

          return ListTile(
            title: Text(city),
            subtitle: Text(weather),
            onTap: () async {
              try {
                final forecast =
                    await _weatherService.fetchFiveDayForecast(city);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      cityName: city,
                      forecast: forecast,
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load forecast: $e')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
