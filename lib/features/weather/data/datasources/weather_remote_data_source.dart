import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
  Future<WeatherModel> getCurrentWeatherByLocation(double lat, double lon);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final DioClient dioClient;
  // TODO: Replace with real API Key or use Environment Variable
  final String _apiKey = 'e86813b30f7e6432035ffefc6aaa1e03';

  WeatherRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
      // Use standard 2.5 API for free keys
      // Note: We can use /data/2.5/weather directly with 'q' parameter for city names
      // without needing separate geocoding call, although geocoding is more precise.
      // For simplicity and matching Free Tier capabilities, we use direct call here if possible,
      // but the most robust way across tiers is usually geocoding first.
      // However, 2.5/weather supports q=CityName.

      final response = await dioClient.dio.get(
        '/data/2.5/weather',
        queryParameters: {'q': cityName, 'appid': _apiKey, 'units': 'metric'},
      );

      return WeatherModel.fromJson(response.data);
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<WeatherModel> getCurrentWeatherByLocation(
    double lat,
    double lon,
  ) async {
    try {
      // Use standard 2.5 API for free keys
      final response = await dioClient.dio.get(
        '/data/2.5/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      return WeatherModel.fromJson(response.data);
    } on DioException {
      throw ServerException();
    }
  }
}
