import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName);
  Future<Either<Failure, Weather>> getCurrentWeatherByLocation(
    double lat,
    double lon,
  );
}
