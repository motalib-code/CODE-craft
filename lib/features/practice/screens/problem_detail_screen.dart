import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highlight/languages/cpp.dart' as cpp;
import 'package:highlight/languages/java.dart' as java;
import 'package:highlight/languages/javascript.dart' as js;
import 'package:highlight/languages/python.dart' as py;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/lc_problems_data.dart';
import '../../../models/lc_problem.dart';
import '../../../models/youtube_video.dart';
import '../../../services/gemini_service.dart';
import '../../../services/youtube_service.dart';

class ProblemDetailScreen extends StatefulWidget {
  const ProblemDetailScreen({
    super.key,
    required this.problemSlug,
    this.problem,
  });

  final String problemSlug;
  final LCProblem? problem;

  @override
  State<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends State<ProblemDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LCProblem _problem;
  final PracticeGeminiService _gemini = PracticeGeminiService();
  final YouTubeService _youtube = YouTubeService();

  bool _loading = true;
  String _language = 'Python';
  late CodeController _codeController;
  Map<String, dynamic>? _review;
  Map<String, dynamic>? _explain;
  List<YouTubeVideo> _videos = <YouTubeVideo>[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _codeController = CodeController(text: '', language: py.python);
    _init();
  }

  Future<void> _init() async {
    _problem = widget.problem ??
        allProblems.firstWhere(
          (p) => p.id.toString() == widget.problemSlug,
          orElse: () => allProblems.first,
        );
    await _loadSavedCode();
    _videos = await _youtube.searchSolutions(_problem);
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  String _codeKey() => 'code_${_problem.id}_${_language.toLowerCase()}';

  Future<void> _loadSavedCode() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_codeKey()) ?? _defaultTemplate();
    _codeController.text = code;
  }

  String _defaultTemplate() {
    switch (_language) {
      case 'Java':
        return 'class Solution {\n  public Object solve() {\n    return null;\n  }\n}';
      case 'C++':
        return 'class Solution {\npublic:\n  int solve() {\n    return 0;\n  }\n};';
      case 'JavaScript':
        return 'function solve() {\n  return null;\n}';
      default:
        return 'def solve():\n    return None';
    }
  }

  dynamic _langDef() {
    switch (_language) {
      case 'Java':
        return java.java;
      case 'C++':
        return cpp.cpp;
      case 'JavaScript':
        return js.javascript;
      default:
        return py.python;
    }
  }

  Future<void> _saveCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_codeKey(), _codeController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code saved locally')),
    );
  }

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: _codeController.text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code copied')),
    );
  }

  Future<void> _resetCode() async {
    setState(() {
      _codeController.text = _defaultTemplate();
    });
  }

  Future<void> _openLeetCode() async {
    await launchUrl(Uri.parse(_problem.lcUrl), mode: LaunchMode.externalApplication);
  }

  Future<void> _reviewCode() async {
    final result = await _gemini.reviewCode(_codeController.text, _language, _problem);
    if (!mounted) return;
    setState(() {
      _review = result;
      _tabController.animateTo(2);
    });
  }

  Future<void> _explainProblem() async {
    final result = await _gemini.explainProblem(_problem);
    if (!mounted) return;
    setState(() {
      _explain = result;
      _tabController.animateTo(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1033),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1033),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1033),
        title: Text('#${_problem.id} ${_problem.title}'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6B5CE7),
          tabs: const [
            Tab(text: 'Problem'),
            Tab(text: 'Code Editor'),
            Tab(text: 'AI Help'),
            Tab(text: 'Videos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProblemTab(),
          _buildCodeEditorTab(),
          _buildAiTab(),
          _buildVideosTab(),
        ],
      ),
    );
  }

  Widget _buildProblemTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(_problem.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _problem.difficulty == 'Easy'
                    ? const Color(0xFF00B8A9)
                    : _problem.difficulty == 'Medium'
                        ? const Color(0xFFFFA116)
                        : const Color(0xFFFF375F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_problem.difficulty, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text(_problem.pattern, style: const TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xFF6B5CE7).withOpacity(0.3),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text('Phase: ${_problem.phase}', style: const TextStyle(color: Colors.white70)),
        Text('Topic: ${_problem.topic} / ${_problem.subtopic}', style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          children: _problem.companies
              .map((c) => Chip(
                    label: Text(c, style: const TextStyle(color: Colors.white, fontSize: 11)),
                    backgroundColor: Colors.orange.withOpacity(0.25),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _openLeetCode,
          icon: const Icon(Icons.open_in_new),
          label: const Text('Open on LeetCode'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _explainProblem,
          icon: const Icon(Icons.smart_toy),
          label: const Text('AI Explain'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
        ),
      ],
    );
  }

  Widget _buildCodeEditorTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Text('Language:', style: TextStyle(color: Colors.white70)),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _language,
              dropdownColor: const Color(0xFF1E1550),
              style: const TextStyle(color: Colors.white),
              items: const ['Python', 'Java', 'C++', 'JavaScript']
                  .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) async {
                if (value == null) return;
                setState(() {
                  _language = value;
                  _codeController = CodeController(
                    text: _defaultTemplate(),
                    language: _langDef(),
                  );
                });
                await _loadSavedCode();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 360,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1550),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF6B5CE7).withOpacity(0.4)),
          ),
          child: CodeTheme(
            data: const CodeThemeData(styles: {}),
            child: CodeField(
              controller: _codeController,
              textStyle: const TextStyle(fontFamily: 'monospace', color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(onPressed: _openLeetCode, child: const Text('Run')),
            ElevatedButton(onPressed: _saveCode, child: const Text('Save')),
            ElevatedButton(onPressed: _copyCode, child: const Text('Copy')),
            ElevatedButton(onPressed: _resetCode, child: const Text('Reset')),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1550),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF6B5CE7).withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Code Review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _reviewCode,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
                icon: const Icon(Icons.smart_toy),
                label: const Text('Review My Code'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAiTab() {
    if (_review == null && _explain == null) {
      return const Center(
        child: Text('Tap AI Explain or Review My Code', style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_review != null) ...[
          _infoCard('Correct', '${_review!['correct']}', (_review!['correct'] == true) ? Colors.green : Colors.red),
          _infoCard('Time Complexity', '${_review!['timeComplexity']}', Colors.teal),
          _infoCard('Space Complexity', '${_review!['spaceComplexity']}', Colors.teal),
          _listCard('Issues', (_review!['issues'] as List?)?.map((e) => '$e').toList() ?? <String>[]),
          _listCard('Improvements', (_review!['improvements'] as List?)?.map((e) => '$e').toList() ?? <String>[]),
          _infoCard('Better Approach', '${_review!['betterApproach']}', const Color(0xFF6B5CE7)),
        ],
        if (_explain != null) ...[
          _infoCard('What Asked', '${_explain!['whatAsked']}', const Color(0xFF6B5CE7)),
          _listCard('Approach', (_explain!['approach'] as List?)?.map((e) => '$e').toList() ?? <String>[]),
          _infoCard('Data Structure', '${_explain!['dataStructure']}', Colors.teal),
          _infoCard('Time Complexity', '${_explain!['timeComplexity']}', Colors.teal),
          _infoCard('Space Complexity', '${_explain!['spaceComplexity']}', Colors.teal),
          _listCard('Common Mistakes', (_explain!['commonMistakes'] as List?)?.map((e) => '$e').toList() ?? <String>[]),
        ],
      ],
    );
  }

  Widget _buildVideosTab() {
    if (_videos.isEmpty) {
      return const Center(child: Text('No videos found', style: TextStyle(color: Colors.white70)));
    }
    return ListView.builder(
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final v = _videos[index];
        return ListTile(
          title: Text(v.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text(v.channelName, style: const TextStyle(color: Colors.white60)),
          trailing: const Icon(Icons.open_in_new, color: Color(0xFF6B5CE7)),
          onTap: () => launchUrl(Uri.parse(v.watchUrl), mode: LaunchMode.externalApplication),
        );
      },
    );
  }

  Widget _infoCard(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1550),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _listCard(String title, List<String> values) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1550),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF6B5CE7), fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...values.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('- $e', style: const TextStyle(color: Colors.white70)),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
