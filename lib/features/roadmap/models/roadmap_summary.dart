class RoadmapSummary {
  final String id;
  final String name;
  final int topicsCount;
  final List<String> sampleTopics;

  RoadmapSummary({
    required this.id,
    required this.name,
    required this.topicsCount,
    required this.sampleTopics,
  });

  factory RoadmapSummary.fromJson(Map<String, dynamic> json) {
    return RoadmapSummary(
      id: json['id'],
      name: json['name'],
      topicsCount: json['topics_count'],
      sampleTopics: List<String>.from(json['sample_topics']),
    );
  }
}
