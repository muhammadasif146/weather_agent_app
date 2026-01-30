part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object> get props => [];
}

class WeatherFetched extends WeatherEvent {
  final String cityName;
  const WeatherFetched(this.cityName);
  @override
  List<Object> get props => [cityName];
}

class WeatherLocationFetched extends WeatherEvent {
  final double lat;
  final double lon;
  const WeatherLocationFetched({required this.lat, required this.lon});
  @override
  List<Object> get props => [lat, lon];
}
