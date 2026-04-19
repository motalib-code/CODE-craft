class GithubRepo {
  final String name;
  final String description;
  final String language;
  final int stars;
  final String url;
  final bool fork;

  const GithubRepo({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
    required this.url,
    required this.fork,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      language: (json['language'] ?? 'Unknown').toString(),
      stars: (json['stargazers_count'] ?? 0) as int,
      url: (json['html_url'] ?? '').toString(),
      fork: (json['fork'] ?? false) as bool,
    );
  }
}

class GithubProfile {
  final String username;
  final String avatarUrl;
  final String name;
  final String bio;
  final String location;
  final int publicRepos;
  final int followers;
  final int following;
  final String htmlUrl;

  const GithubProfile({
    required this.username,
    required this.avatarUrl,
    required this.name,
    required this.bio,
    required this.location,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.htmlUrl,
  });

  factory GithubProfile.fromJson(Map<String, dynamic> json) {
    return GithubProfile(
      username: (json['login'] ?? '').toString(),
      avatarUrl: (json['avatar_url'] ?? '').toString(),
      name: (json['name'] ?? json['login'] ?? '').toString(),
      bio: (json['bio'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      publicRepos: (json['public_repos'] ?? 0) as int,
      followers: (json['followers'] ?? 0) as int,
      following: (json['following'] ?? 0) as int,
      htmlUrl: (json['html_url'] ?? '').toString(),
    );
  }
}
