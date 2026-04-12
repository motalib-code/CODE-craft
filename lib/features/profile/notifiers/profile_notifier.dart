import 'package:flutter_riverpod/flutter_riverpod.dart';

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
