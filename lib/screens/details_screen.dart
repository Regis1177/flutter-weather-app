import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String cityName;
  final List<Map<String, dynamic>> forecast;

  const DetailsScreen({
    super.key,
    required this.cityName,
    required this.forecast,
  });

  String _getWindDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees / 45).round()) % 8;
    return directions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('5-Day Forecast for $cityName')),
      body: ListView.builder(
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final day = forecast[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day['date'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.network(
                        "https://openweathermap.org/img/w/${day['icon']}.png",
                        width: 50,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Temperature: ${day['temp']}°C"),
                          Text("Description: ${day['description']}"),
                          Text(
                              "Wind: ${day['wind_speed']} m/s (${_getWindDirection(day['wind_deg'])})"),
                          Text("Humidity: ${day['humidity']}%"),
                          Text("Cloudiness: ${day['clouds']}%"),
                          Text("Rain: ${day['rain']} mm"),
                          Text("Snow: ${day['snow']} mm"),
                          Text("Probability of precipitation: ${day['pop']}%"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
