import '../entities/agent_insight.dart';
import '../../../weather/domain/entities/weather.dart';

abstract class AgentDataSource {
  Future<AgentInsight> getInsight(Weather weather);
}
