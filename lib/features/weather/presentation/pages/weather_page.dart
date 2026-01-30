import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../agent/presentation/bloc/agent_bloc.dart';
import '../../../agent/presentation/widgets/agent_insight_display.dart';
import '../bloc/weather_bloc/weather_bloc.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<WeatherBloc>()),
        BlocProvider(create: (_) => sl<AgentBloc>()),
      ],
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text('Weather Agent'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter city name',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<WeatherBloc>().add(
                        WeatherFetched(_controller.text),
                      );
                      // Clear previous insight
                      // context.read<AgentBloc>().add(ResetAgent()); // Optional if implemented
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<WeatherBloc>().add(WeatherFetched(value));
                }
              },
            ),
            const SizedBox(height: 20),

            // Weather Display
            Expanded(
              child: BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  if (state is WeatherSuccess) {
                    context.read<AgentBloc>().add(
                      AnalyzeWeather(state.weather),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherFailure) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  } else if (state is WeatherSuccess) {
                    final weather = state.weather;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weather.cityName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${weather.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          weather.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Agent Insight
                        BlocBuilder<AgentBloc, AgentState>(
                          builder: (context, agentState) {
                            if (agentState is AgentLoading) {
                              return const CircularProgressIndicator();
                            } else if (agentState is AgentInsightReady) {
                              return AgentInsightDisplay(
                                insight: agentState.insight,
                              );
                            } else if (agentState is AgentFailure) {
                              return Text(agentState.message);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: Text(
                      'Search for a city to get weather & insights',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
