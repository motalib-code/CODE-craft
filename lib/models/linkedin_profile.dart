class Experience {
  final String company;
  final String title;
  final String startDate;
  final String endDate;
  final String description;
  final bool isCurrent;

  const Experience({
    required this.company,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.isCurrent,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    final end = (json['endDate'] ?? '').toString();
    return Experience(
      company: (json['company'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      startDate: (json['startDate'] ?? '').toString(),
      endDate: end,
      description: (json['description'] ?? '').toString(),
      isCurrent: end.isEmpty || end.toLowerCase() == 'present',
    );
  }
}

class Education {
  final String school;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;

  const Education({
    required this.school,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      school: (json['school'] ?? '').toString(),
      degree: (json['degree'] ?? '').toString(),
      fieldOfStudy: (json['fieldOfStudy'] ?? '').toString(),
      startDate: (json['startDate'] ?? '').toString(),
      endDate: (json['endDate'] ?? '').toString(),
    );
  }
}

class LinkedInProfile {
  final String fullName;
  final String headline;
  final String summary;
  final String profilePicture;
  final List<Experience> experiences;
  final List<Education> educations;
  final List<String> skills;
  final List<Map<String, String>> certifications;
  final int recommendations;
  final int connectionsCount;

  const LinkedInProfile({
    required this.fullName,
    required this.headline,
    required this.summary,
    required this.profilePicture,
    required this.experiences,
    required this.educations,
    required this.skills,
    required this.certifications,
    required this.recommendations,
    required this.connectionsCount,
  });

  factory LinkedInProfile.fromJson(Map<String, dynamic> json) {
    final experiencesRaw = (json['experiences'] as List? ?? <dynamic>[])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final educationsRaw = (json['educations'] as List? ?? <dynamic>[])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return LinkedInProfile(
      fullName: (json['fullName'] ?? '').toString(),
      headline: (json['headline'] ?? '').toString(),
      summary: (json['summary'] ?? '').toString(),
      profilePicture: (json['profilePicture'] ?? '').toString(),
      experiences: experiencesRaw.map(Experience.fromJson).toList(),
      educations: educationsRaw.map(Education.fromJson).toList(),
      skills: (json['skills'] as List? ?? <dynamic>[])
          .map((s) => s.toString())
          .where((s) => s.isNotEmpty)
          .toList(),
      certifications: (json['certifications'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((c) => {
                'name': (c['name'] ?? '').toString(),
                'authority': (c['authority'] ?? '').toString(),
                'url': (c['url'] ?? '').toString(),
              })
          .toList(),
      recommendations: (json['recommendationsCount'] ?? 0) as int,
      connectionsCount: (json['connectionsCount'] ?? 0) as int,
    );
  }
}
