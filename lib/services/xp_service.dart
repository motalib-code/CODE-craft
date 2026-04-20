import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class XPManager {
  static int xpForDifficulty(String diff) =>
      diff == 'Easy' ? 15 : diff == 'Medium' ? 25 : 40;

  static String badgeForXP(int xp) {
    if (xp >= 5000) return 'Grandmaster';
    if (xp >= 2000) return 'Diamond';
    if (xp >= 1000) return 'Gold';
    if (xp >= 500) return 'Silver';
    if (xp >= 100) return 'Bronze';
    return 'Beginner';
  }
}

class XPState {
  final int totalXp;
  final int streakDays;
  final DateTime? lastSolvedDate;
  final List<int> solvedIds;

  const XPState({
    required this.totalXp,
    required this.streakDays,
    required this.lastSolvedDate,
    required this.solvedIds,
  });

  XPState copyWith({
    int? totalXp,
    int? streakDays,
    DateTime? lastSolvedDate,
    List<int>? solvedIds,
  }) {
    return XPState(
      totalXp: totalXp ?? this.totalXp,
      streakDays: streakDays ?? this.streakDays,
      lastSolvedDate: lastSolvedDate ?? this.lastSolvedDate,
      solvedIds: solvedIds ?? this.solvedIds,
    );
  }
}

class XPService {
  static const String _kSolvedProblems = 'solved_problems';
  static const String _kTotalXp = 'total_xp';
  static const String _kStreak = 'streak_days';
  static const String _kLastSolvedDate = 'last_solved_date';

  Future<XPState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final solvedRaw = prefs.getString(_kSolvedProblems);
    final List<int> solved = solvedRaw == null
        ? <int>[]
        : (jsonDecode(solvedRaw) as List).map((e) => e as int).toList();

    return XPState(
      totalXp: prefs.getInt(_kTotalXp) ?? 0,
      streakDays: prefs.getInt(_kStreak) ?? 0,
      lastSolvedDate: DateTime.tryParse(prefs.getString(_kLastSolvedDate) ?? ''),
      solvedIds: solved,
    );
  }

  Future<XPState> toggleSolved({
    required int problemId,
    required String difficulty,
    required XPState current,
    required bool solved,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<int> updatedSolved = List<int>.from(current.solvedIds);
    int updatedXp = current.totalXp;

    if (solved && !updatedSolved.contains(problemId)) {
      updatedSolved.add(problemId);
      updatedXp += XPManager.xpForDifficulty(difficulty);
    } else if (!solved && updatedSolved.contains(problemId)) {
      updatedSolved.remove(problemId);
      updatedXp -= XPManager.xpForDifficulty(difficulty);
      if (updatedXp < 0) updatedXp = 0;
    }

    int updatedStreak = current.streakDays;
    DateTime? updatedDate = current.lastSolvedDate;

    if (solved) {
      final DateTime today = DateTime.now();
      if (current.lastSolvedDate == null) {
        updatedStreak = 1;
      } else {
        final int gap = DateTime(today.year, today.month, today.day)
            .difference(DateTime(current.lastSolvedDate!.year, current.lastSolvedDate!.month, current.lastSolvedDate!.day))
            .inDays;
        if (gap == 0) {
          updatedStreak = current.streakDays;
        } else if (gap == 1) {
          updatedStreak = current.streakDays + 1;
        } else {
          updatedStreak = 1;
        }
      }
      updatedDate = today;
    }

    await prefs.setString(_kSolvedProblems, jsonEncode(updatedSolved));
    await prefs.setInt(_kTotalXp, updatedXp);
    await prefs.setInt(_kStreak, updatedStreak);
    if (updatedDate != null) {
      await prefs.setString(_kLastSolvedDate, updatedDate.toIso8601String());
    }

    return XPState(
      totalXp: updatedXp,
      streakDays: updatedStreak,
      lastSolvedDate: updatedDate,
      solvedIds: updatedSolved,
    );
  }
}
