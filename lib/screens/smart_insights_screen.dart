import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/gemini_service.dart';
import '../services/groq_service.dart';

class SmartInsightsScreen extends StatefulWidget {
  const SmartInsightsScreen({super.key});

  @override
  State<SmartInsightsScreen> createState() => _SmartInsightsScreenState();
}

class _SmartInsightsScreenState extends State<SmartInsightsScreen> {
  int resumeScore = 78;
  int totalInterviews = 12;
  double avgInterviewScore = 7.4;
  int lcSolved = 48;
  int streak = 5;
  List<double> recentScores = [5.8, 6.4, 7.2, 8.0, 7.5, 8.1, 7.8];

  final TextEditingController roleController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  bool isAnalyzing = false;
  String skillGapResult = '';
  bool isLoadingTip = false;
  String companyTips = '';

  final List<Map<String, dynamic>> pathSteps = [
    {'title': 'Build a strong resume', 'completed': false},
    {'title': 'Complete coding drills', 'completed': false},
    {'title': 'Mock interview practice', 'completed': false},
    {'title': 'Apply to startup & FAANG', 'completed': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      resumeScore = prefs.getInt('insights_resume_score') ?? resumeScore;
      totalInterviews = prefs.getInt('insights_total_interviews') ?? totalInterviews;
      avgInterviewScore = prefs.getDouble('insights_avg_interview_score') ?? avgInterviewScore;
      lcSolved = prefs.getInt('insights_lc_solved') ?? lcSolved;
      streak = prefs.getInt('insights_streak') ?? streak;
      for (int i = 0; i < pathSteps.length; i++) {
        pathSteps[i]['completed'] = prefs.getBool('path_step_$i') ?? false;
      }
    });
  }

  Future<void> _savePathStep(int index, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pathSteps[index]['completed'] = completed;
    });
    await prefs.setBool('path_step_$index', completed);
  }

  Future<void> _analyzeSkillGap() async {
    if (roleController.text.trim().isEmpty || skillsController.text.trim().isEmpty) {
      setState(() {
        skillGapResult = 'Enter your target role and existing skills to analyze your gap.';
      });
      return;
    }

    setState(() {
      isAnalyzing = true;
      skillGapResult = '';
    });

    try {
      final prompt = '''Analyze the skill gap for this role.
Role: ${roleController.text.trim()}
Current Skills: ${skillsController.text.trim()}
Return JSON with keys: 
{"skill_gap": ["..."], "recommended_learning": ["..."], "priority_focus": ["..."]}
      ''';
      final result = await CareerGeminiService().generateJson(prompt: prompt);
      setState(() {
        skillGapResult = result.entries
            .map((e) => '${e.key}: ${e.value is List ? (e.value as List).join(', ') : e.value}')
            .join('\n\n');
      });
    } catch (e) {
      setState(() {
        skillGapResult = 'Unable to analyze skill gap right now. Try again later.';
      });
    } finally {
      setState(() => isAnalyzing = false);
    }
  }

  Future<void> _fetchCompanyTips() async {
    final company = companyController.text.trim();
    if (company.isEmpty) {
      setState(() {
        companyTips = 'Enter a company name to get preparation tips.';
      });
      return;
    }

    setState(() {
      isLoadingTip = true;
      companyTips = '';
    });

    try {
      final tips = await GroqService.getCompanyInterviewTips(company);
      setState(() {
        companyTips = tips;
      });
    } catch (e) {
      setState(() {
        companyTips = 'Could not fetch company tips right now.';
      });
    } finally {
      setState(() => isLoadingTip = false);
    }
  }

  Widget _statCard(String label, String value, {Color color = Colors.white}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1550),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Insights'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Progress'),
              Tab(text: 'Skill Gap'),
              Tab(text: 'Path'),
              Tab(text: 'Tips'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProgressTab(),
            _buildSkillGapTab(),
            _buildPathTab(),
            _buildTipsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _statCard('Resume Score', '$resumeScore'),
              const SizedBox(width: 12),
              _statCard('Interviews', '$totalInterviews'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard('Avg Score', avgInterviewScore.toStringAsFixed(1)),
              const SizedBox(width: 12),
              _statCard('LeetCode Solved', '$lcSolved'),
            ],
          ),
          const SizedBox(height: 12),
          _statCard('Streak', '$streak days', color: Colors.greenAccent),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1550),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Interview Trend', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return SideTitleWidget(axisSide: meta.axisSide, child: Text(labels[index.clamp(0, 6)], style: const TextStyle(color: Colors.white54, fontSize: 10)));
                        })),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 38, getTitlesWidget: (value, meta) => SideTitleWidget(axisSide: meta.axisSide, child: Text(value.toInt().toString(), style: const TextStyle(color: Colors.white54, fontSize: 10))))),
                      ),
                      minX: 0,
                      maxX: 6,
                      minY: 4,
                      maxY: 10,
                      lineBarsData: [
                        LineChartBarData(
                          spots: recentScores.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                          isCurved: true,
                          barWidth: 3,
                          color: const Color(0xFF6B5CE7),
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Placement Readiness', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                LinearPercentIndicator(
                  lineHeight: 18,
                  percent: resumeScore / 100,
                  progressColor: const Color(0xFF6B5CE7),
                  backgroundColor: Colors.white12,
                  center: Text('${resumeScore}%', style: const TextStyle(color: Colors.white)),
                  barRadius: const Radius.circular(14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillGapTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: roleController,
            decoration: const InputDecoration(hintText: 'Target role (e.g. Software Engineer)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: skillsController,
            decoration: const InputDecoration(hintText: 'Current skills (comma separated)'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAnalyzing ? null : _analyzeSkillGap,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
              child: Text(isAnalyzing ? 'Analyzing...' : 'Analyze Skill Gap'),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1550),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(skillGapResult.isEmpty ? 'Your skill gap summary will appear here.' : skillGapResult,
                style: const TextStyle(color: Colors.white70, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildPathTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: pathSteps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return Card(
            color: const Color(0xFF1E1550),
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              title: Text(step['title'], style: const TextStyle(color: Colors.white)),
              trailing: Checkbox(
                value: step['completed'] as bool,
                onChanged: (value) => _savePathStep(index, value ?? false),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daily tips', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _tipCard('Practice one strong data structure every day.'),
          _tipCard('Read company interview experiences before applying.'),
          _tipCard('Pair programming helps you explain your code clearly.'),
          const SizedBox(height: 18),
          const Text('Company prep', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            controller: companyController,
            decoration: const InputDecoration(hintText: 'Company name for custom tips'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoadingTip ? null : _fetchCompanyTips,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B5CE7)),
              child: Text(isLoadingTip ? 'Fetching Tips...' : 'Get Company Tips'),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1550),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(companyTips.isEmpty ? 'Company-specific tips will appear here.' : companyTips,
                style: const TextStyle(color: Colors.white70, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _tipCard(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1550),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70, height: 1.5)),
    );
  }

  @override
  void dispose() {
    roleController.dispose();
    skillsController.dispose();
    companyController.dispose();
    super.dispose();
  }
}
