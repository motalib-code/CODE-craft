import 'package:flutter_riverpod/flutter_riverpod.dart';

final gamificationNotifierProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier();
});

class GamificationState {
  final String tab;
  final List<LeaderboardEntry> entries;
  final bool isLoading;

  const GamificationState({
    this.tab = 'National',
    this.entries = const [],
    this.isLoading = false,
  });
}

class LeaderboardEntry {
  final String name;
  final String college;
  final int xp;
  final int rank;
  final int streak;

  const LeaderboardEntry({
    required this.name,
    required this.college,
    required this.xp,
    required this.rank,
    this.streak = 0,
  });
}

class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier() : super(const GamificationState()) {
    _load();
  }

  void _load() {
    state = const GamificationState(
      entries: [
        LeaderboardEntry(name: 'Arjun Verma', college: 'IIT Delhi', xp: 15200, rank: 1, streak: 45),
        LeaderboardEntry(name: 'Priya Singh', college: 'NIT Trichy', xp: 14800, rank: 2, streak: 38),
        LeaderboardEntry(name: 'Rahul Kumar', college: 'BITS Pilani', xp: 13900, rank: 3, streak: 52),
        LeaderboardEntry(name: 'Sneha Patel', college: 'IIT Bombay', xp: 12800, rank: 4, streak: 28),
        LeaderboardEntry(name: 'Vikram Reddy', college: 'IIIT Hyderabad', xp: 12100, rank: 5, streak: 33),
        LeaderboardEntry(name: 'Aisha Khan', college: 'NIT Warangal', xp: 11500, rank: 6, streak: 22),
        LeaderboardEntry(name: 'Karthik Nair', college: 'IIT Madras', xp: 11200, rank: 7, streak: 41),
        LeaderboardEntry(name: 'Deepika Sharma', college: 'DTU', xp: 10800, rank: 8, streak: 19),
        LeaderboardEntry(name: 'Rohan Gupta', college: 'NIT Surathkal', xp: 10400, rank: 9, streak: 37),
        LeaderboardEntry(name: 'Meera Joshi', college: 'COEP', xp: 10100, rank: 10, streak: 25),
        LeaderboardEntry(name: 'Ankit Mishra', college: 'VIT Vellore', xp: 9800, rank: 11, streak: 15),
        LeaderboardEntry(name: 'Pooja Rao', college: 'RVCE', xp: 9500, rank: 12, streak: 30),
      ],
    );
  }

  void setTab(String tab) {
    state = GamificationState(tab: tab, entries: state.entries);
  }
}
