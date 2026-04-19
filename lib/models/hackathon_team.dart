class RequiredRole {
  final String role;
  final List<String> skills;
  final String importance;
  final String githubSearchQuery;
  final String linkedinSearchQuery;

  const RequiredRole({
    required this.role,
    required this.skills,
    required this.importance,
    required this.githubSearchQuery,
    required this.linkedinSearchQuery,
  });

  factory RequiredRole.fromJson(Map<String, dynamic> json) {
    return RequiredRole(
      role: (json['role'] ?? '').toString(),
      skills: (json['skills'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      importance: (json['importance'] ?? 'important').toString(),
      githubSearchQuery: (json['githubSearchQuery'] ?? '').toString(),
      linkedinSearchQuery: (json['linkedinSearchQuery'] ?? '').toString(),
    );
  }
}

class ProblemAnalysis {
  final String problemSummary;
  final List<RequiredRole> requiredRoles;
  final List<String> techStack;
  final String winningStrategy;
  final String yourRole;

  const ProblemAnalysis({
    required this.problemSummary,
    required this.requiredRoles,
    required this.techStack,
    required this.winningStrategy,
    required this.yourRole,
  });

  factory ProblemAnalysis.fromJson(Map<String, dynamic> json) {
    return ProblemAnalysis(
      problemSummary: (json['problemSummary'] ?? '').toString(),
      requiredRoles: (json['requiredRoles'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => RequiredRole.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      techStack: (json['techStack'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      winningStrategy: (json['winningStrategy'] ?? '').toString(),
      yourRole: (json['yourRole'] ?? '').toString(),
    );
  }
}

class TeamCandidate {
  final String githubUsername;
  final String name;
  final int matchScore;
  final List<String> matchReasons;
  final List<String> topSkills;
  final List<Map<String, dynamic>> topRepos;
  final String githubUrl;
  final String avatarUrl;
  final String contactSuggestion;
  final String? linkedinUrl;

  const TeamCandidate({
    required this.githubUsername,
    required this.name,
    required this.matchScore,
    required this.matchReasons,
    required this.topSkills,
    required this.topRepos,
    required this.githubUrl,
    required this.avatarUrl,
    required this.contactSuggestion,
    this.linkedinUrl,
  });

  factory TeamCandidate.fromJson(Map<String, dynamic> json) {
    return TeamCandidate(
      githubUsername: (json['githubUsername'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      matchScore: (json['matchScore'] ?? 0) as int,
      matchReasons: (json['matchReasons'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      topSkills: (json['topSkills'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      topRepos: (json['topRepos'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      githubUrl: (json['githubUrl'] ?? '').toString(),
      avatarUrl: (json['avatarUrl'] ?? '').toString(),
      contactSuggestion: (json['contactSuggestion'] ?? '').toString(),
      linkedinUrl: json['linkedinUrl']?.toString(),
    );
  }
}

class TeamRecommendation {
  final String role;
  final TeamCandidate candidate;

  const TeamRecommendation({required this.role, required this.candidate});

  factory TeamRecommendation.fromJson(Map<String, dynamic> json) {
    return TeamRecommendation(
      role: (json['role'] ?? '').toString(),
      candidate: TeamCandidate.fromJson(
        Map<String, dynamic>.from(json['candidate'] as Map? ?? <String, dynamic>{}),
      ),
    );
  }
}

class HackathonTeamResult {
  final List<TeamRecommendation> recommendedTeam;
  final int teamChemistryScore;
  final String winProbability;
  final List<String> teamStrengths;
  final List<String> teamWeaknesses;
  final String pitchAdvice;

  const HackathonTeamResult({
    required this.recommendedTeam,
    required this.teamChemistryScore,
    required this.winProbability,
    required this.teamStrengths,
    required this.teamWeaknesses,
    required this.pitchAdvice,
  });

  factory HackathonTeamResult.fromJson(Map<String, dynamic> json) {
    return HackathonTeamResult(
      recommendedTeam: (json['recommendedTeam'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => TeamRecommendation.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      teamChemistryScore: (json['teamChemistryScore'] ?? 0) as int,
      winProbability: (json['winProbability'] ?? '0%').toString(),
      teamStrengths: (json['teamStrengths'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      teamWeaknesses: (json['teamWeaknesses'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      pitchAdvice: (json['pitchAdvice'] ?? '').toString(),
    );
  }
}
