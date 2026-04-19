import 'github_profile.dart';
import 'linkedin_profile.dart';

class UserProfile {
  final String githubUsername;
  final String linkedinUrl;
  final String name;
  final String bio;
  final String avatarUrl;
  final String location;
  final String college;
  final int githubRepos;
  final int githubStars;
  final int githubFollowers;
  final int linkedinConnections;
  final List<String> skills;
  final List<Experience> experiences;
  final List<Education> educations;
  final List<GithubRepo> topRepos;
  final Map<String, int> languageStats;
  final int profileStrengthScore;
  final List<Map<String, String>> connectionSuggestions;
  final List<String> networkInsights;

  const UserProfile({
    required this.githubUsername,
    required this.linkedinUrl,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.location,
    required this.college,
    required this.githubRepos,
    required this.githubStars,
    required this.githubFollowers,
    required this.linkedinConnections,
    required this.skills,
    required this.experiences,
    required this.educations,
    required this.topRepos,
    required this.languageStats,
    required this.profileStrengthScore,
    required this.connectionSuggestions,
    required this.networkInsights,
  });

  int get totalExperienceItems => experiences.length;
}
