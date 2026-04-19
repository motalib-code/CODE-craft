import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/resume_report.dart';
import '../providers/resume_provider.dart';
import '../widgets/resume_score_card.dart';

class ResumeCheckerScreen extends ConsumerStatefulWidget {
  const ResumeCheckerScreen({super.key});

  @override
  ConsumerState<ResumeCheckerScreen> createState() => _ResumeCheckerScreenState();
}

class _ResumeCheckerScreenState extends ConsumerState<ResumeCheckerScreen> {
  final _resumeCtrl = TextEditingController();

  @override
  void dispose() {
    _resumeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resumeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Resume Checker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(resumeProvider).pickFile();
                      _resumeCtrl.text = ref.read(resumeProvider).resumeText;
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload PDF'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () => ref.read(resumeProvider).analyzeResume(_resumeCtrl.text),
                    child: Text(state.isLoading ? 'Checking...' : 'Check My Resume'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _resumeCtrl,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Or paste your resume text here...',
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 10),
              Text(state.error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 16),
            if (state.report != null) _ReportView(report: state.report!),
          ],
        ),
      ),
      bottomNavigationBar: state.report == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: () => ref.read(resumeProvider).downloadSuggestionPdf(),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Download Improved Suggestions as PDF'),
              ),
            ),
    );
  }
}

class _ReportView extends StatelessWidget {
  final ResumeReport report;

  const _ReportView({required this.report});

  @override
  Widget build(BuildContext context) {
    final statusColor = report.atsScore > 70
        ? Colors.green
        : report.atsScore >= 50
            ? Colors.orange
            : Colors.red;

    final statusText = report.atsScore > 70
        ? 'ATS Friendly'
        : report.atsScore >= 50
            ? 'Needs Improvement'
            : 'Not ATS Friendly';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResumeScoreCard(score: report.overallScore),
        const SizedBox(height: 12),
        Card(
          color: statusColor.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$statusText (${report.atsScore}/100)',
                  style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: report.atsScore / 100,
                  color: statusColor,
                  backgroundColor: Colors.white12,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: const Color(0xFF21184A),
          child: ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.zero,
            children: report.sections.entries
                .map(
                  (entry) => ExpansionPanelRadio(
                    value: entry.key,
                    headerBuilder: (_, __) {
                      return ListTile(
                        title: Text(_toTitle(entry.key)),
                        subtitle: Text('${entry.value.score}/100 • ${entry.value.status}'),
                        trailing: Text(_statusEmoji(entry.value.status)),
                      );
                    },
                    body: ListTile(
                      title: Text(entry.value.feedback),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        _chipBlock('Strengths', report.strengths, Colors.green),
        const SizedBox(height: 12),
        Card(
          color: const Color(0xFF21184A),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: report.improvements
                  .map(
                    (i) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: i.priority == 'high'
                            ? Colors.red
                            : i.priority == 'medium'
                                ? Colors.orange
                                : Colors.green,
                        child: Text(
                          i.priority.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(i.suggestion),
                      subtitle: Text(i.example),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _chipBlock('Missing Keywords', report.missingKeywords, Colors.redAccent),
        const SizedBox(height: 12),
        _chipBlock('Action Verbs Present', report.actionVerbsPresent, Colors.green),
        const SizedBox(height: 12),
        _chipBlock('Action Verbs Missing', report.actionVerbsMissing, Colors.orange),
      ],
    );
  }

  Widget _chipBlock(String title, List<String> items, Color color) {
    return Card(
      color: const Color(0xFF21184A),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items
                  .map((e) => Chip(label: Text(e), backgroundColor: color.withOpacity(0.2)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _toTitle(String raw) {
    return raw[0].toUpperCase() + raw.substring(1);
  }

  String _statusEmoji(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return '✅';
      case 'warning':
        return '⚠️';
      default:
        return '❌';
    }
  }
}
