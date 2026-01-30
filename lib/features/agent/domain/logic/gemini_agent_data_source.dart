import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../weather/domain/entities/weather.dart';
import '../entities/agent_insight.dart';
import 'agent_data_source.dart';

class GeminiAgentDataSource implements AgentDataSource {
  final GenerativeModel _model;

  GeminiAgentDataSource(String apiKey)
    : _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  @override
  Future<AgentInsight> getInsight(Weather weather) async {
    final prompt =
        '''
    You are a helpful weather assistant. Based on the following weather data, provide a short insight and a recommendation.
    
    Weather Data:
    - City: ${weather.cityName}
    - Temperature: ${weather.temperature}°C
    - Condition: ${weather.mainCondition} (${weather.description})
    - Humidity: ${weather.humidity}%
    - Wind Speed: ${weather.windSpeed} m/s

    The output should be extremely concise. 
    Format the response exactly as follows:
    Message: [Your insight here]
    Recommendation: [Your action recommendation here]
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text;

      if (text == null) {
        return const AgentInsight(
          message: 'Could not analyze weather.',
          iconAssetName: 'assets/error.png',
          actionRecommendation: 'Try again later.',
        );
      }

      // Simple parsing logic (robustness would require JSON mode or better parsing)
      final lines = text.split('\n');
      String message = 'Weather analysis complete.';
      String recommendation = 'Enjoy your day.';

      for (var line in lines) {
        if (line.trim().startsWith('Message:')) {
          message = line.replaceAll('Message:', '').trim();
        } else if (line.trim().startsWith('Recommendation:')) {
          recommendation = line.replaceAll('Recommendation:', '').trim();
        }
      }

      return AgentInsight(
        message: message,
        iconAssetName: 'assets/ai.png', // Placeholder AI icon
        actionRecommendation: recommendation,
      );
    } catch (e) {
      // Fallback or error handling
      return const AgentInsight(
        message: 'AI Service Unavailable.',
        iconAssetName: 'assets/error.png',
        actionRecommendation: 'Using standard weather advice.',
      );
    }
  }
}
