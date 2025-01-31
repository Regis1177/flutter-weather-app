import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = const String.fromEnvironment('WEATHER_API_KEY');

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
}
