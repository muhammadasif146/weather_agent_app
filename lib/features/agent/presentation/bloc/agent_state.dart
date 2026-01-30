part of 'agent_bloc.dart';

abstract class AgentState extends Equatable {
  const AgentState();
  @override
  List<Object> get props => [];
}

class AgentInitial extends AgentState {}

class AgentLoading extends AgentState {}

class AgentInsightReady extends AgentState {
  final AgentInsight insight;
  const AgentInsightReady(this.insight);
  @override
  List<Object> get props => [insight];
}

class AgentFailure extends AgentState {
  final String message;
  const AgentFailure(this.message);
  @override
  List<Object> get props => [message];
}
