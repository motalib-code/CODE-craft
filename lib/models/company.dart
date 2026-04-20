class Company {
  final String name;
  final String slug;
  final String logoEmoji;
  final String tier;
  final String problemsUrl;
  final List<String> focusAreas;
  final int totalProblems;

  const Company({
    required this.name,
    required this.slug,
    required this.logoEmoji,
    required this.tier,
    required this.problemsUrl,
    required this.focusAreas,
    required this.totalProblems,
  });
}

class CompanyDSA {
  final String company;
  final String driveUrl;
  final String tricks;
  final String githubUrl;
  final String faangPlaybookUrl;

  const CompanyDSA({
    required this.company,
    required this.driveUrl,
    required this.tricks,
    required this.githubUrl,
    required this.faangPlaybookUrl,
  });
}
