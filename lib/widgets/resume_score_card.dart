import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResumeScoreCard extends StatelessWidget {
  final int score;

  const ResumeScoreCard({super.key, required this.score});

  Color get _scoreColor {
    if (score > 70) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF21184A),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 70,
              lineWidth: 10,
              percent: (score / 100).clamp(0, 1),
              progressColor: _scoreColor,
              center: Text(
                '$score',
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Resume Score'),
          ],
        ),
      ),
    );
  }
}
