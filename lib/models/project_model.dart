class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String owner;
  final String repoName;
  final String readmeUrl; // raw.githubusercontent.com wala link
  final List<String> tags;
  final String sector; // "SIH", "ROS", "Flutter", "General"

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.repoName,
    required this.readmeUrl,
    required this.tags,
    required this.sector,
  });

  String get githubUrl => 'https://github.com/$owner/$repoName';
}
