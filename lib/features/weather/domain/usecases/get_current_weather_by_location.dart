import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class LocationParams {
  final double lat;
  final double lon;
  const LocationParams({required this.lat, required this.lon});
}

class GetCurrentWeatherByLocation implements UseCase<Weather, LocationParams> {
  final WeatherRepository repository;

  GetCurrentWeatherByLocation(this.repository);

  @override
  Future<Either<Failure, Weather>> call(LocationParams params) async {
    return await repository.getCurrentWeatherByLocation(params.lat, params.lon);
  }
}
