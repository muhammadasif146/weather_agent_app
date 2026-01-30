import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_data_source.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName) async {
    try {
      final weather = await remoteDataSource.getCurrentWeather(cityName);
      localDataSource.cacheWeather(weather);
      return Right(weather);
    } on ServerException {
      try {
        final localWeather = await localDataSource.getLastWeather();
        return Right(localWeather);
      } on CacheException {
        return const Left(CacheFailure('No cached data available'));
      }
    }
  }

  @override
  Future<Either<Failure, Weather>> getCurrentWeatherByLocation(
    double lat,
    double lon,
  ) async {
    try {
      final weather = await remoteDataSource.getCurrentWeatherByLocation(
        lat,
        lon,
      );
      localDataSource.cacheWeather(weather);
      return Right(weather);
    } on ServerException {
      try {
        final localWeather = await localDataSource.getLastWeather();
        return Right(localWeather);
      } on CacheException {
        return const Left(CacheFailure('No cached data available'));
      }
    }
  }
}
