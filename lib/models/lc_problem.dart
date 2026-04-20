class LCProblem {
  final int id;
  final String title;
  final String difficulty;
  final String phase;
  final String topic;
  final String subtopic;
  final String lcUrl;
  final List<String> companies;
  final String pattern;
  bool isSolved;
  bool isBookmarked;

  LCProblem({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.phase,
    required this.topic,
    required this.subtopic,
    required this.lcUrl,
    required this.companies,
    required this.pattern,
    this.isSolved = false,
    this.isBookmarked = false,
  });

  LCProblem copyWith({
    int? id,
    String? title,
    String? difficulty,
    String? phase,
    String? topic,
    String? subtopic,
    String? lcUrl,
    List<String>? companies,
    String? pattern,
    bool? isSolved,
    bool? isBookmarked,
  }) {
    return LCProblem(
      id: id ?? this.id,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      phase: phase ?? this.phase,
      topic: topic ?? this.topic,
      subtopic: subtopic ?? this.subtopic,
      lcUrl: lcUrl ?? this.lcUrl,
      companies: companies ?? this.companies,
      pattern: pattern ?? this.pattern,
      isSolved: isSolved ?? this.isSolved,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
