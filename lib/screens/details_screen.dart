import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String cityName;
  final List<Map<String, dynamic>> forecast;

  const DetailsScreen(
      {super.key, required this.cityName, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('5-Day Forecast for $cityName')),
      body: ListView.builder(
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final day = forecast[index];
          return ListTile(
            title: Text("${day['date']}"),
            subtitle: Text("${day['temp']}°C, ${day['description']}"),
            leading: Image.network(
              "https://openweathermap.org/img/w/${day['icon']}.png",
              width: 50,
            ),
          );
        },
      ),
    );
  }
}
