class CityWeather {
  final String cityName;
  final String description;
  final String icon;
  final double temperature;

  CityWeather({
    required this.cityName,
    required this.description,
    required this.icon,
    required this.temperature,
  });

  factory CityWeather.fromJson(Map<String, dynamic> json) {
    return CityWeather(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temperature: json['main']['temp'],
    );
  }
}
