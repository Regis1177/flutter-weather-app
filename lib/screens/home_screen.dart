import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _cities = [
    'Warszawa',
    'Kraków',
    'Łódź',
    'Wrocław',
    'Poznań'
  ];
  final WeatherService _weatherService = WeatherService();
  final Map<String, String> _weatherData = {};

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    for (final city in _cities) {
      try {
        final weather = await _weatherService.fetchWeather(city);
        setState(() {
          _weatherData[city] =
              '${weather['main']['temp']}°C, ${weather['weather'][0]['description']}';
        });
      } catch (e) {
        setState(() {
          _weatherData[city] = 'Błąd: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather in Polish Cities'),
      ),
      body: ListView.builder(
        itemCount: _cities.length,
        itemBuilder: (context, index) {
          final city = _cities[index];
          final weather = _weatherData[city] ?? 'Ładowanie...';
          return ListTile(
            title: Text(city),
            subtitle: Text(weather),
          );
        },
      ),
    );
  }
}
