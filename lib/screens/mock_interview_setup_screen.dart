import 'package:flutter/material.dart';
import '../screens/mock_interview_active_screen.dart';

class MockInterviewSetupScreen extends StatefulWidget {
  const MockInterviewSetupScreen({super.key});

  @override
  State<MockInterviewSetupScreen> createState() => _MockInterviewSetupScreenState();
}

class _MockInterviewSetupScreenState extends State<MockInterviewSetupScreen> {
  String selectedType = 'Technical DSA';
  String selectedCompany = 'Google';
  String selectedLevel = 'Fresher';
  int selectedDuration = 30;
  double difficulty = 1.0;
  String selectedLanguage = 'English';
  final TextEditingController companyController = TextEditingController();

  final List<String> interviewTypes = [
    'Technical DSA',
    'System Design',
    'HR Behavioral',
    'Frontend',
    'Backend',
    'Full Stack',
    'AI/ML',
    'React Native',
    'Flutter',
  ];

  final Map<String, String> companyEmojis = {
    'Google': '🔍',
    'Amazon': '📦',
    'Microsoft': '🪟',
    'Meta': '👥',
    'Apple': '🍎',
    'Netflix': '🎬',
    'Flipkart': '🛒',
    'Swiggy': '🍕',
    'Zomato': '🍽️',
    'PhonePe': '📱',
    'Paytm': '💸',
    'Startup': '🚀',
    'Generic': '🏢',
  };

  final List<String> levels = ['Fresher', '1-3 yrs', '3-5 yrs', '5+ yrs'];
  final List<int> durations = [15, 30, 45, 60];
  final List<String> languages = ['English', 'Hindi', 'Hinglish'];

  String get companyName {
    if (companyController.text.trim().isNotEmpty) {
      return companyController.text.trim();
    }
    return selectedCompany;
  }

  String get difficultyLabel {
    if (difficulty <= 0.5) return 'Easy';
    if (difficulty <= 1.5) return 'Medium';
    return 'Hard';
  }

  Color get difficultyColor {
    if (difficulty <= 0.5) return Colors.green;
    if (difficulty <= 1.5) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    companyController.dispose();
    super.dispose();
  }

  Widget buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1550),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6B5CE7).withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estimatedQuestions = (selectedDuration / 4).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Setup Mock Interview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSection(
              title: '🎯 Interview Type',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: interviewTypes.map((type) {
                  final selected = selectedType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: selected,
                    selectedColor: const Color(0xFF6B5CE7),
                    backgroundColor: const Color(0xFF2B1F5D),
                    onSelected: (_) => setState(() => selectedType = type),
                  );
                }).toList(),
              ),
            ),
            buildSection(
              title: '🏢 Target Company',
              child: Column(
                children: [
                  TextField(
                    controller: companyController,
                    decoration: InputDecoration(
                      hintText: 'Enter company name',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          companyController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: companyEmojis.entries.map((entry) {
                      final label = '${entry.value} ${entry.key}';
                      final selected = selectedCompany == entry.key && companyController.text.isEmpty;
                      return FilterChip(
                        label: Text(label, style: const TextStyle(color: Colors.white)),
                        selected: selected,
                        selectedColor: const Color(0xFF6B5CE7),
                        backgroundColor: const Color(0xFF2B1F5D),
                        onSelected: (_) {
                          companyController.clear();
                          setState(() => selectedCompany = entry.key);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            buildSection(
              title: '📊 Experience Level',
              child: Wrap(
                spacing: 12,
                children: levels.map((level) {
                  return ChoiceChip(
                    label: Text(level),
                    selected: selectedLevel == level,
                    selectedColor: const Color(0xFF6B5CE7),
                    backgroundColor: const Color(0xFF2B1F5D),
                    onSelected: (_) => setState(() => selectedLevel = level),
                  );
                }).toList(),
              ),
            ),
            buildSection(
              title: '⏱ Duration',
              child: Wrap(
                spacing: 10,
                children: durations.map((minutes) {
                  final selected = selectedDuration == minutes;
                  return ChoiceChip(
                    label: Text('$minutes min'),
                    selected: selected,
                    selectedColor: const Color(0xFF6B5CE7),
                    backgroundColor: const Color(0xFF2B1F5D),
                    onSelected: (_) => setState(() => selectedDuration = minutes),
                  );
                }).toList(),
              ),
            ),
            buildSection(
              title: '💪 Difficulty',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: difficulty,
                    min: 0,
                    max: 2,
                    divisions: 2,
                    activeColor: difficultyColor,
                    inactiveColor: Colors.white12,
                    label: difficultyLabel,
                    onChanged: (value) => setState(() => difficulty = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text('Easy'), Text('Medium'), Text('Hard')],
                  ),
                ],
              ),
            ),
            buildSection(
              title: '🗣 Language',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: languages.map((lang) {
                  return ChoiceChip(
                    label: Text(lang),
                    selected: selectedLanguage == lang,
                    selectedColor: const Color(0xFF6B5CE7),
                    backgroundColor: const Color(0xFF2B1F5D),
                    onSelected: (_) => setState(() => selectedLanguage = lang),
                  );
                }).toList(),
              ),
            ),
            buildSection(
              title: 'Estimated Questions',
              child: Text(
                '~$estimatedQuestions questions in $selectedDuration minutes',
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF6B5CE7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MockInterviewActiveScreen(
                        interviewType: selectedType,
                        company: companyName,
                        level: selectedLevel,
                        durationMinutes: selectedDuration,
                        difficulty: difficultyLabel,
                        language: selectedLanguage,
                      ),
                    ),
                  );
                },
                child: const Text('🎤 Start Mock Interview', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
