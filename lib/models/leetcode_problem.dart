class LeetCodeProblem {
  final String id;
  final String title;
  final String titleSlug;
  final String difficulty; // Easy/Medium/Hard
  final List<String> tags;
  final double acceptanceRate;
  final bool isPremium;
  final String? status; // null/attempted/solved
  final String? content; // HTML description
  final List<String>? hints;
  final List<String>? exampleTestcases;
  final int likes;
  final int dislikes;
  final List<String>? similarQuestions;

  int get xpReward {
    switch (difficulty) {
      case 'Easy':
        return 15;
      case 'Medium':
        return 25;
      case 'Hard':
        return 40;
      default:
        return 10;
    }
  }

  LeetCodeProblem({
    required this.id,
    required this.title,
    required this.titleSlug,
    required this.difficulty,
    required this.tags,
    required this.acceptanceRate,
    required this.isPremium,
    this.status,
    this.content,
    this.hints,
    this.exampleTestcases,
    this.likes = 0,
    this.dislikes = 0,
    this.similarQuestions,
  });

  factory LeetCodeProblem.fromJson(Map<String, dynamic> json) {
    return LeetCodeProblem(
      id: json['questionFrontendId'] ?? json['questionId'] ?? '',
      title: json['title'] ?? '',
      titleSlug: json['titleSlug'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      tags: List<String>.from(
        (json['topicTags'] as List?)?.map((tag) => tag['name'] ?? tag) ?? [],
      ),
      acceptanceRate: double.tryParse(json['acRate']?.toString() ?? '0') ?? 0,
      isPremium: json['isPaidOnly'] ?? false,
      status: json['status'],
      content: json['content'],
      hints: List<String>.from((json['hints'] as List?) ?? []),
      exampleTestcases: List<String>.from((json['exampleTestcaseList'] as List?) ?? []),
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'questionFrontendId': id,
        'title': title,
        'titleSlug': titleSlug,
        'difficulty': difficulty,
        'topicTags': tags.map((t) => {'name': t}).toList(),
        'acRate': acceptanceRate,
        'isPaidOnly': isPremium,
        'status': status,
        'content': content,
        'hints': hints ?? [],
        'exampleTestcaseList': exampleTestcases ?? [],
        'likes': likes,
        'dislikes': dislikes,
      };
}
