import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();

  // Lista wszystkich stolic województw w Polsce
  final List<String> _cities = [
    'Warsaw', // Mazowieckie
    'Krakow', // Małopolskie
    'Lodz', // Łódzkie
    'Wroclaw', // Dolnośląskie
    'Poznan', // Wielkopolskie
    'Gdansk', // Pomorskie
    'Szczecin', // Zachodniopomorskie
    'Bydgoszcz', // Kujawsko-pomorskie
    'Lublin', // Lubelskie
    'Bialystok', // Podlaskie
    'Katowice', // Śląskie
    'Rzeszow', // Podkarpackie
    'Olsztyn', // Warmińsko-mazurskie
    'Opole', // Opolskie
    'Kielce', // Świętokrzyskie
    'Zielona Gora' // Lubuskie
  ];

  final Map<String, Map<String, dynamic>?> _weatherData = {};

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    for (final city in _cities) {
      try {
        final data = await _weatherService.fetchWeather(city);
        if (!mounted) return;
        setState(() {
          _weatherData[city] = {
            'temp': "${data['main']['temp']}°C",
            'description': data['weather'][0]['description'],
            'icon': data['weather'][0]['icon'],
          };
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _weatherData[city] = {
            'temp': 'Error',
            'description': 'Failed to load',
            'icon': null,
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather in Polish Cities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _cities.length,
        itemBuilder: (context, index) {
          final city = _cities[index];
          final weather = _weatherData[city];
          final iconUrl = (weather != null && weather['icon'] != null)
              ? "https://openweathermap.org/img/w/${weather['icon']}.png"
              : null;

          return ListTile(
            leading: iconUrl != null
                ? Image.network(
                    iconUrl,
                    width: 40,
                    height: 40,
                  )
                : const Icon(Icons.error),
            title: Text(city),
            subtitle: Text(
              weather != null
                  ? "${weather['temp']}, ${weather['description']}"
                  : 'Loading...',
            ),
            onTap: () async {
              try {
                final forecast =
                    await _weatherService.fetchFiveDayForecast(city);
                if (!mounted) return;
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
                if (!mounted) return;
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
