import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../../features/weather/data/datasources/weather_local_data_source.dart';
import '../../features/weather/data/datasources/weather_remote_data_source.dart';
import '../../features/weather/data/repositories/weather_repository_impl.dart';
import '../../features/weather/domain/repositories/weather_repository.dart';
import '../../features/weather/domain/usecases/get_current_weather.dart';
import '../../features/weather/domain/usecases/get_current_weather_by_location.dart';
import '../../features/weather/presentation/bloc/weather_bloc/weather_bloc.dart';
import '../../features/agent/domain/logic/agent_data_source.dart';
import '../../features/agent/domain/logic/gemini_agent_data_source.dart';
import '../../features/agent/domain/logic/rule_based_agent_data_source.dart';
import '../../features/agent/domain/repositories/agent_repository.dart';
import '../../features/agent/domain/usecases/get_agent_insight.dart';
import '../../features/agent/presentation/bloc/agent_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Weather
  // Bloc
  sl.registerFactory(
    () =>
        WeatherBloc(getCurrentWeather: sl(), getCurrentWeatherByLocation: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentWeather(sl()));
  sl.registerLazySingleton(() => GetCurrentWeatherByLocation(sl()));

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Agent
  // Bloc
  sl.registerFactory(() => AgentBloc(getAgentInsight: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAgentInsight(sl()));

  // Repository & Data Sources
  sl.registerLazySingleton(
    () => AgentRepository(
      ruleBasedSource: sl(instanceName: 'RuleBased'),
      llmSource: sl(instanceName: 'LLM'),
    ),
  );

  sl.registerLazySingleton<AgentDataSource>(
    () => RuleBasedAgentDataSource(),
    instanceName: 'RuleBased',
  );

  // NOTE: In a real app, API Key should be secure
  sl.registerLazySingleton<AgentDataSource>(
    () => GeminiAgentDataSource('YOUR_GEMINI_API_KEY'),
    instanceName: 'LLM',
  );

  // Helper for repository injection
  sl.registerFactory<AgentDataSource>(() => sl(instanceName: 'RuleBased'));

  //! Core
  sl.registerLazySingleton(() => DioClient());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
