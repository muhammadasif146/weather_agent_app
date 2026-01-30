import '../../../weather/domain/entities/weather.dart';
import '../entities/agent_insight.dart';
import 'agent_data_source.dart';

class RuleBasedAgentDataSource implements AgentDataSource {
  @override
  Future<AgentInsight> getInsight(Weather weather) async {
    // Condition 1: Rain
    if (weather.mainCondition.toLowerCase().contains('rain') ||
        weather.description.toLowerCase().contains('rain')) {
      return const AgentInsight(
        message: 'It looks like it might rain.',
        iconAssetName: 'assets/rain.png',
        actionRecommendation: 'Carry an umbrella!',
      );
    }

    // Condition 2: Extreme Heat
    if (weather.temperature > 30) {
      return const AgentInsight(
        message: 'It is getting hot out there.',
        iconAssetName: 'assets/hot.png',
        actionRecommendation: 'Stay hydrated and wear sunscreen.',
      );
    }

    // Condition 3: Cold
    if (weather.temperature < 10) {
      return const AgentInsight(
        message: 'It is quite cold today.',
        iconAssetName: 'assets/cold.png',
        actionRecommendation: 'Wear a jacket and keep warm.',
      );
    }

    // Condition 4: Wind
    if (weather.windSpeed > 10) {
      // arbitrary threshold for example
      return const AgentInsight(
        message: 'It is getting windy.',
        iconAssetName: 'assets/wind.png',
        actionRecommendation: 'Secure loose items and drive carefully.',
      );
    }

    // Condition 5: High Humidity
    if (weather.humidity > 85) {
      return const AgentInsight(
        message: 'It is very humid.',
        iconAssetName: 'assets/humidity.png',
        actionRecommendation: 'Wear breathable clothing.',
      );
    }

    return const AgentInsight(
      message: 'The weather looks pleasant.',
      iconAssetName: 'assets/sunny.png',
      actionRecommendation: 'Good day for a walk or outdoor activites.',
    );
  }
}
