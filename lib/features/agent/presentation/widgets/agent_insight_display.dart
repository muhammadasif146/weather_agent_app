import 'package:flutter/material.dart';
import '../../domain/entities/agent_insight.dart';

class AgentInsightDisplay extends StatelessWidget {
  final AgentInsight insight;

  const AgentInsightDisplay({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // In a real app, use asset images or IconData based on insight.iconAssetName
                const Icon(Icons.lightbulb, color: Colors.amber, size: 30),
                const SizedBox(width: 10),
                Text(
                  'Agent Insight',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              insight.message,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.recommend,
                    size: 20,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    insight.actionRecommendation,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
