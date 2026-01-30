import 'package:equatable/equatable.dart';

class AgentInsight extends Equatable {
  final String message;
  final String iconAssetName;
  final String actionRecommendation;

  const AgentInsight({
    required this.message,
    required this.iconAssetName,
    required this.actionRecommendation,
  });

  @override
  List<Object?> get props => [message, iconAssetName, actionRecommendation];
}
