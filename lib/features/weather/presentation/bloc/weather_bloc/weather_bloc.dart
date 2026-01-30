import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/weather.dart';
import '../../../domain/usecases/get_current_weather.dart';
import '../../../domain/usecases/get_current_weather_by_location.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather _getCurrentWeather;
  final GetCurrentWeatherByLocation _getCurrentWeatherByLocation;

  WeatherBloc({
    required GetCurrentWeather getCurrentWeather,
    required GetCurrentWeatherByLocation getCurrentWeatherByLocation,
  }) : _getCurrentWeather = getCurrentWeather,
       _getCurrentWeatherByLocation = getCurrentWeatherByLocation,
       super(WeatherInitial()) {
    on<WeatherFetched>(_onWeatherFetched);
    on<WeatherLocationFetched>(_onWeatherLocationFetched);
  }

  Future<void> _onWeatherFetched(
    WeatherFetched event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    final result = await _getCurrentWeather(event.cityName);
    result.fold(
      (failure) => emit(WeatherFailure(failure.message)),
      (weather) => emit(WeatherSuccess(weather)),
    );
  }

  Future<void> _onWeatherLocationFetched(
    WeatherLocationFetched event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    final result = await _getCurrentWeatherByLocation(
      LocationParams(lat: event.lat, lon: event.lon),
    );
    result.fold(
      (failure) => emit(WeatherFailure(failure.message)),
      (weather) => emit(WeatherSuccess(weather)),
    );
  }
}
