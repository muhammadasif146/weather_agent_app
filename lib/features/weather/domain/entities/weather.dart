import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final String description;
  final String mainCondition;
  final String cityName;
  final int humidity;
  final double windSpeed;

  const Weather({
    required this.temperature,
    required this.description,
    required this.mainCondition,
    required this.cityName,
    required this.humidity,
    required this.windSpeed,
  });

  @override
  List<Object?> get props => [
    temperature,
    description,
    mainCondition,
    cityName,
    humidity,
    windSpeed,
  ];
}
