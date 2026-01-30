import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../weather/domain/entities/weather.dart';
import '../repositories/agent_repository.dart';
import '../entities/agent_insight.dart';

class GetAgentInsight implements UseCase<AgentInsight, Weather> {
  final AgentRepository repository;

  GetAgentInsight(this.repository);

  @override
  Future<Either<Failure, AgentInsight>> call(Weather weather) async {
    try {
      final insight = await repository.getInsight(weather);
      return Right(insight);
    } catch (e) {
      return const Left(CacheFailure('Failed to generate insight'));
    }
  }
}
