class ResumeSectionReport {
  final int score;
  final String status;
  final String feedback;

  const ResumeSectionReport({
    required this.score,
    required this.status,
    required this.feedback,
  });

  factory ResumeSectionReport.fromJson(Map<String, dynamic> json) {
    return ResumeSectionReport(
      score: (json['score'] ?? 0) as int,
      status: (json['status'] ?? 'missing').toString(),
      feedback: (json['feedback'] ?? '').toString(),
    );
  }
}

class ResumeImprovement {
  final String priority;
  final String suggestion;
  final String example;

  const ResumeImprovement({
    required this.priority,
    required this.suggestion,
    required this.example,
  });

  factory ResumeImprovement.fromJson(Map<String, dynamic> json) {
    return ResumeImprovement(
      priority: (json['priority'] ?? 'medium').toString(),
      suggestion: (json['suggestion'] ?? '').toString(),
      example: (json['example'] ?? '').toString(),
    );
  }
}

class ResumeReport {
  final int overallScore;
  final int atsScore;
  final String atsStatus;
  final Map<String, ResumeSectionReport> sections;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<ResumeImprovement> improvements;
  final List<String> missingKeywords;
  final List<String> formattingIssues;
  final List<String> actionVerbsPresent;
  final List<String> actionVerbsMissing;
  final int quantificationScore;
  final String summary;

  const ResumeReport({
    required this.overallScore,
    required this.atsScore,
    required this.atsStatus,
    required this.sections,
    required this.strengths,
    required this.weaknesses,
    required this.improvements,
    required this.missingKeywords,
    required this.formattingIssues,
    required this.actionVerbsPresent,
    required this.actionVerbsMissing,
    required this.quantificationScore,
    required this.summary,
  });

  factory ResumeReport.fromJson(Map<String, dynamic> json) {
    final rawSections =
        Map<String, dynamic>.from(json['sections'] as Map? ?? <String, dynamic>{});
    final sectionModels = <String, ResumeSectionReport>{};

    for (final entry in rawSections.entries) {
      if (entry.value is Map<String, dynamic>) {
        sectionModels[entry.key] = ResumeSectionReport.fromJson(entry.value);
      } else if (entry.value is Map) {
        sectionModels[entry.key] = ResumeSectionReport.fromJson(
          Map<String, dynamic>.from(entry.value as Map),
        );
      }
    }

    final actionVerbs =
        Map<String, dynamic>.from(json['actionVerbs'] as Map? ?? <String, dynamic>{});

    return ResumeReport(
      overallScore: (json['overallScore'] ?? 0) as int,
      atsScore: (json['atsScore'] ?? 0) as int,
      atsStatus: (json['atsStatus'] ?? 'Needs Work').toString(),
      sections: sectionModels,
      strengths: (json['strengths'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      weaknesses: (json['weaknesses'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      improvements: (json['improvements'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => ResumeImprovement.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      missingKeywords: (json['missingKeywords'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      formattingIssues: (json['formattingIssues'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      actionVerbsPresent: (actionVerbs['present'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      actionVerbsMissing: (actionVerbs['missing'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      quantificationScore: (json['quantificationScore'] ?? 0) as int,
      summary: (json['summary'] ?? '').toString(),
    );
  }
}
