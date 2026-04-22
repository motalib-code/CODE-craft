class ResumeAnalysis {
  final int overallScore;
  final int atsScore;
  final List<String> strengths;
  final List<String> improvements;

  ResumeAnalysis({
    required this.overallScore,
    required this.atsScore,
    required this.strengths,
    required this.improvements,
  });

  factory ResumeAnalysis.fromMap(Map<String, dynamic> map) {
    return ResumeAnalysis(
      overallScore: (map['overall_score'] as num?)?.toInt() ?? 0,
      atsScore: (map['ats_score'] as num?)?.toInt() ?? 0,
      strengths: List<String>.from(map['strengths'] ?? []),
      improvements: List<String>.from(map['improvements'] ?? []),
    );
  }
}
