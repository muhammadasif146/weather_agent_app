import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.temperature,
    required super.description,
    required super.mainCondition,
    required super.cityName,
    required super.humidity,
    required super.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Check for One Call API structure
    if (json.containsKey('current')) {
      final current = json['current'] as Map<String, dynamic>;
      final weatherList = current['weather'] as List;
      final weatherData = weatherList.isNotEmpty ? weatherList[0] : {};

      return WeatherModel(
        temperature: (current['temp'] as num).toDouble(),
        description: weatherData['description'] ?? '',
        mainCondition: weatherData['main'] ?? '',
        cityName: '', // Name is handled separately or not available in OneCall
        humidity: (current['humidity'] as num).toInt(),
        windSpeed: (current['wind_speed'] as num).toDouble(),
      );
    }

    // OpenWeatherMap 2.5 JSON structure mapping
    final weatherList = json['weather'] as List;
    final weatherData = weatherList.isNotEmpty ? weatherList[0] : {};
    final mainData = json['main'] as Map<String, dynamic>;
    final windData = json['wind'] as Map<String, dynamic>;

    return WeatherModel(
      temperature: (mainData['temp'] as num).toDouble(),
      description: weatherData['description'] ?? '',
      mainCondition: weatherData['main'] ?? '',
      cityName: json['name'] ?? '',
      humidity: (mainData['humidity'] as num).toInt(),
      windSpeed: (windData['speed'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weather': [
        {'main': mainCondition, 'description': description},
      ],
      'main': {'temp': temperature, 'humidity': humidity},
      'wind': {'speed': windSpeed},
      'name': cityName,
    };
  }

  WeatherModel copyWith({
    double? temperature,
    String? description,
    String? mainCondition,
    String? cityName,
    int? humidity,
    double? windSpeed,
  }) {
    return WeatherModel(
      temperature: temperature ?? this.temperature,
      description: description ?? this.description,
      mainCondition: mainCondition ?? this.mainCondition,
      cityName: cityName ?? this.cityName,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
    );
  }
}
