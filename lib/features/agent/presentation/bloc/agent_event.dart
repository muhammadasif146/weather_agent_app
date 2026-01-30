part of 'agent_bloc.dart';

abstract class AgentEvent extends Equatable {
  const AgentEvent();
  @override
  List<Object> get props => [];
}

class AnalyzeWeather extends AgentEvent {
  final Weather weather;
  const AnalyzeWeather(this.weather);
  @override
  List<Object> get props => [weather];
}
