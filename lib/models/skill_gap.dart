class SkillGap {
  final List<String> gaps;
  final List<String> recommendedSkills;
  final List<String> focusAreas;

  SkillGap({
    required this.gaps,
    required this.recommendedSkills,
    required this.focusAreas,
  });

  factory SkillGap.fromMap(Map<String, dynamic> map) {
    return SkillGap(
      gaps: List<String>.from(map['skill_gap'] ?? []),
      recommendedSkills: List<String>.from(map['recommended_learning'] ?? []),
      focusAreas: List<String>.from(map['priority_focus'] ?? []),
    );
  }
}
