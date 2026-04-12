class ProblemModel {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<String> tags;
  final String category;
  final int coins;
  final int xp;
  final String boilerplate;
  final List<TestCase> testCases;
  final String? hint;
  final String? solution;
  final int solvedCount;
  final double acceptanceRate;

  const ProblemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    this.tags = const [],
    this.category = 'General',
    this.coins = 10,
    this.xp = 50,
    this.boilerplate = '',
    this.testCases = const [],
    this.hint,
    this.solution,
    this.solvedCount = 0,
    this.acceptanceRate = 0.0,
  });

  factory ProblemModel.fromMap(Map<String, dynamic> map) {
    return ProblemModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      difficulty: map['difficulty'] ?? 'Easy',
      tags: List<String>.from(map['tags'] ?? []),
      category: map['category'] ?? 'General',
      coins: map['coins'] ?? 10,
      xp: map['xp'] ?? 50,
      boilerplate: map['boilerplate'] ?? '',
      testCases: (map['testCases'] as List?)
              ?.map((tc) => TestCase.fromMap(tc))
              .toList() ??
          [],
      hint: map['hint'],
      solution: map['solution'],
      solvedCount: map['solvedCount'] ?? 0,
      acceptanceRate: (map['acceptanceRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'tags': tags,
        'category': category,
        'coins': coins,
        'xp': xp,
        'boilerplate': boilerplate,
        'testCases': testCases.map((tc) => tc.toMap()).toList(),
        'hint': hint,
        'solution': solution,
        'solvedCount': solvedCount,
        'acceptanceRate': acceptanceRate,
      };
}

class TestCase {
  final String input;
  final String expectedOutput;
  final bool isHidden;

  const TestCase({
    required this.input,
    required this.expectedOutput,
    this.isHidden = false,
  });

  factory TestCase.fromMap(Map<String, dynamic> map) => TestCase(
        input: map['input'] ?? '',
        expectedOutput: map['expectedOutput'] ?? '',
        isHidden: map['isHidden'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'input': input,
        'expectedOutput': expectedOutput,
        'isHidden': isHidden,
      };
}
