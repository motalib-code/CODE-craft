import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/github_profile_model.dart';
import '../../../core/services/github_service.dart';

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});

class ProfileState {
  final int selectedTab;
  final bool isLoading;

  const ProfileState({this.selectedTab = 0, this.isLoading = false});
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState());

  void setTab(int tab) {
    state = ProfileState(selectedTab: tab);
  }
}

final githubProfileProvider = FutureProvider.family<GitHubProfile, String>((ref, username) async {
  return await GithubService.fetchGitHubProfile(username);
});

// Save to Firestore
Future<void> updateProfileWithGitHub(WidgetRef ref, String uid, GitHubProfile gh) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'githubUsername': gh.username,
    'avatarUrl': gh.avatarUrl,           // profile image update
    'bio': gh.bio ?? '',
    'githubTopRepos': gh.topRepos.map((r) => {
      'name': r.name,
      'description': r.description,
      'stars': r.stars,
      'language': r.language,
      'url': r.htmlUrl,
    }).toList(),
  });
}
