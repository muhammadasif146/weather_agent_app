part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final Weather weather;
  const WeatherSuccess(this.weather);
  @override
  List<Object> get props => [weather];
}

class WeatherFailure extends WeatherState {
  final String message;
  const WeatherFailure(this.message);
  @override
  List<Object> get props => [message];
}
