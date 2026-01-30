import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/agent_insight.dart';
import '../../domain/usecases/get_agent_insight.dart';
import '../../../weather/domain/entities/weather.dart';

part 'agent_event.dart';
part 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  final GetAgentInsight _getAgentInsight;

  AgentBloc({required GetAgentInsight getAgentInsight})
    : _getAgentInsight = getAgentInsight,
      super(AgentInitial()) {
    on<AnalyzeWeather>(_onAnalyzeWeather);
  }

  Future<void> _onAnalyzeWeather(
    AnalyzeWeather event,
    Emitter<AgentState> emit,
  ) async {
    emit(AgentLoading());
    // Since our logic is synchronous/fast in this example, it will be quick.
    // If we were using an LLM API, this would be async.
    final result = await _getAgentInsight(event.weather);
    result.fold(
      (failure) => emit(const AgentFailure('Could not generate insight')),
      (insight) => emit(AgentInsightReady(insight)),
    );
  }
}
