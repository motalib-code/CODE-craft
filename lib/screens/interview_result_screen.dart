import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InterviewResultScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  final List<Map<String, dynamic>> questionResults;
  final String company;
  final String interviewType;

  const InterviewResultScreen({
    super.key,
    required this.report,
    required this.questionResults,
    required this.company,
    required this.interviewType,
  });

  @override
  Widget build(BuildContext context) {
    final overallScore = (report['overall_score'] as num?)?.toDouble() ?? 0.0;
    final grade = report['grade']?.toString() ?? 'B';
    final hireRecommendation = report['hire_recommendation']?.toString() ?? 'Maybe';
    final feedback = report['overall_feedback']?.toString() ?? '';
    final strengths = List<String>.from(report['top_strengths'] ?? []);
    final improvements = List<String>.from(report['top_improvements'] ?? []);
    final nextSteps = List<String>.from(report['next_steps'] ?? []);

    return Scaffold(
      appBar: AppBar(title: const Text('Interview Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$company • $interviewType', style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 8),
            Text('Ready Score', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1550),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(overallScore.toStringAsFixed(1), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Grade $grade', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(label: Text(hireRecommendation, style: const TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF6B5CE7)),
                    const SizedBox(height: 8),
                    Text('Feedback', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 140,
                      child: Text(feedback, style: const TextStyle(color: Colors.white54), maxLines: 4, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _sectionTitle('Top Strengths'),
            _tagWrap(strengths, Colors.greenAccent),
            const SizedBox(height: 16),
            _sectionTitle('Top Improvements'),
            _tagWrap(improvements, Colors.orangeAccent),
            const SizedBox(height: 16),
            _sectionTitle('Next Steps'),
            ...nextSteps.map((step) => ListTile(
                  leading: const Icon(Icons.arrow_right, color: Color(0xFF6B5CE7)),
                  title: Text(step, style: const TextStyle(color: Colors.white70)),
                )),
            const SizedBox(height: 20),
            _sectionTitle('Question Breakdown'),
            ...questionResults.map((result) {
              final eval = result['evaluation'] as Map<String, dynamic>? ?? {};
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1550),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result['question'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text(result['answer'] ?? '', style: const TextStyle(color: Colors.white54)),
                    const SizedBox(height: 10),
                    Text('Score: ${eval['score'] ?? '-'} • Clarity: ${eval['clarity'] ?? '-'}', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    if ((eval['improvements'] is List))
                      Text('Improve: ${(eval['improvements'] as List).join(', ')}', style: const TextStyle(color: Colors.orangeAccent)),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B5CE7),
                minimumSize: const Size.fromHeight(52),
              ),
              child: const Text('Back to Home'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse('https://www.example.com/prepare-more');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('View Recommended Resources'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B1F5D),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _tagWrap(List<String> items, Color color) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => Chip(label: Text(item), backgroundColor: color.withOpacity(0.25), labelStyle: const TextStyle(color: Colors.white))).toList(),
    );
  }
}
