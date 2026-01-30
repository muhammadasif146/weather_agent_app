import '../../../weather/domain/entities/weather.dart';
import '../entities/agent_insight.dart';
import '../logic/agent_data_source.dart';

class AgentRepository {
  final AgentDataSource ruleBasedSource;
  final AgentDataSource llmSource;
  // In a real app, this could be a user preference stored in SharedPreferences
  bool useLLM = false;

  AgentRepository({required this.ruleBasedSource, required this.llmSource});

  void setUseLLM(bool value) {
    useLLM = value;
  }

  Future<AgentInsight> getInsight(Weather weather) async {
    if (useLLM) {
      try {
        return await llmSource.getInsight(weather);
      } catch (e) {
        // Fallback to rules if LLM fails
        return await ruleBasedSource.getInsight(weather);
      }
    } else {
      return await ruleBasedSource.getInsight(weather);
    }
  }
}
