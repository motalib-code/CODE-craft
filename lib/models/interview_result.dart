class InterviewResult {
  final double overallScore;
  final String grade;
  final String hireRecommendation;
  final String overallFeedback;
  final List<String> topStrengths;
  final List<String> topImprovements;
  final List<String> nextSteps;

  InterviewResult({
    required this.overallScore,
    required this.grade,
    required this.hireRecommendation,
    required this.overallFeedback,
    required this.topStrengths,
    required this.topImprovements,
    required this.nextSteps,
  });

  factory InterviewResult.fromMap(Map<String, dynamic> map) {
    return InterviewResult(
      overallScore: (map['overall_score'] as num?)?.toDouble() ?? 0.0,
      grade: map['grade']?.toString() ?? 'B',
      hireRecommendation: map['hire_recommendation']?.toString() ?? 'Maybe',
      overallFeedback: map['overall_feedback']?.toString() ?? '',
      topStrengths: List<String>.from(map['top_strengths'] ?? []),
      topImprovements: List<String>.from(map['top_improvements'] ?? []),
      nextSteps: List<String>.from(map['next_steps'] ?? []),
    );
  }
}
