import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class XPNotifier extends StateNotifier<int> {
  XPNotifier() : super(0) {
    _loadXP();
  }

  Future<void> _loadXP() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getInt('total_xp') ?? 0;
    } catch (e) {
      print('Error loading XP: $e');
    }
  }

  Future<void> addXP(int amount) async {
    state += amount;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('total_xp', state);
    } catch (e) {
      print('Error saving XP: $e');
    }
  }

  String get badge {
    if (state >= 5000) return '🏆 Grandmaster';
    if (state >= 2000) return '💎 Diamond';
    if (state >= 1000) return '🥇 Gold';
    if (state >= 500) return '🥈 Silver';
    if (state >= 100) return '🥉 Bronze';
    return '🌱 Beginner';
  }
}

final xpProvider = StateNotifierProvider<XPNotifier, int>(
  (ref) => XPNotifier(),
);

// Streak tracking
class StreakNotifier extends StateNotifier<int> {
  StreakNotifier() : super(0) {
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSolvedDateStr = prefs.getString('last_solved_date');
      final currentStreak = prefs.getInt('current_streak') ?? 0;

      if (lastSolvedDateStr == null) {
        state = 0;
        return;
      }

      final lastDate = DateTime.parse(lastSolvedDateStr);
      final today = DateTime.now();
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        state = currentStreak;
      } else if (difference > 1) {
        state = 0;
      } else {
        state = currentStreak;
      }
    } catch (e) {
      print('Error loading streak: $e');
    }
  }

  Future<void> markSolved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSolvedDateStr = prefs.getString('last_solved_date');
      final lastDate =
          lastSolvedDateStr != null ? DateTime.parse(lastSolvedDateStr) : null;
      final today = DateTime.now();

      if (lastDate == null || today.difference(lastDate).inDays >= 1) {
        state += 1;
        await prefs.setInt('current_streak', state);
      }

      await prefs.setString('last_solved_date', today.toIso8601String());
    } catch (e) {
      print('Error marking solved: $e');
    }
  }
}

final streakProvider = StateNotifierProvider<StreakNotifier, int>(
  (ref) => StreakNotifier(),
);

// Solved problems tracking
class SolvedProblemsNotifier extends StateNotifier<List<String>> {
  SolvedProblemsNotifier() : super([]) {
    _loadSolvedProblems();
  }

  Future<void> _loadSolvedProblems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getStringList('solved_problems') ?? [];
    } catch (e) {
      print('Error loading solved problems: $e');
    }
  }

  Future<void> markAsSolved(String problemId) async {
    if (!state.contains(problemId)) {
      state = [...state, problemId];
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('solved_problems', state);
      } catch (e) {
        print('Error saving solved problem: $e');
      }
    }
  }

  bool isSolved(String problemId) => state.contains(problemId);
  int get solvedCount => state.length;
}

final solvedProblemsProvider =
    StateNotifierProvider<SolvedProblemsNotifier, List<String>>(
  (ref) => SolvedProblemsNotifier(),
);

// Solved today tracking
final solvedTodayProvider = StateProvider<int>((ref) => 0);

// Rank calculation (based on XP)
final rankProvider = Provider<int>((ref) {
  final xp = ref.watch(xpProvider);
  return (xp / 100).ceil(); // Simple rank calculation
});
