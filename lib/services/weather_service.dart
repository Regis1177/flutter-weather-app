import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = dotenv.env['WEATHER_API_KEY']!;

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data for $city');
    }
  }

  Future<List<Map<String, dynamic>>> fetchFiveDayForecast(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List forecasts = data['list'];

      return forecasts.map((forecast) {
        return {
          'date': forecast['dt_txt'],
          'temp': forecast['main']['temp'],
          'description': forecast['weather'][0]['description'],
          'icon': forecast['weather'][0]['icon'],
          'wind_speed': forecast['wind']['speed'],
          'wind_deg': forecast['wind']['deg'],
          'humidity': forecast['main']['humidity'],
          'clouds': forecast['clouds']['all'],
          'rain': forecast['rain'] != null ? forecast['rain']['3h'] ?? 0 : 0,
          'snow': forecast['snow'] != null ? forecast['snow']['3h'] ?? 0 : 0,
          'pop': forecast['pop'] != null ? forecast['pop'] * 100 : 0,
        };
      }).toList();
    } else {
      throw Exception('Failed to load 5-day forecast for $city');
    }
  }
}
