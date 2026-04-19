class GitHubProfile {
  final String username;
  final String avatarUrl;
  final String? name;
  final String? bio;
  final String? location;
  final int followers;
  final int following;
  final List<GitHubRepo> topRepos;

  GitHubProfile({
    required this.username,
    required this.avatarUrl,
    this.name,
    this.bio,
    this.location,
    required this.followers,
    required this.following,
    required this.topRepos,
  });
}

class GitHubRepo {
  final String name;
  final String? description;
  final int stars;
  final String? language;
  final String htmlUrl;

  GitHubRepo({
    required this.name,
    this.description,
    required this.stars,
    this.language,
    required this.htmlUrl,
  });
}
