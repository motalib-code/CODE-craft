import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/problem_model.dart';
import '../../../models/job_model.dart';

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

class HomeState {
  final bool isLoading;
  final int streak;
  final List<int> streakDays;
  final ProblemModel? dailyChallenge;
  final int solved;
  final int rank;
  final double accuracy;
  final List<Map<String, dynamic>> continueTopics;
  final List<Map<String, dynamic>> topCoders;
  final List<JobModel> jobs;

  const HomeState({
    this.isLoading = false,
    this.streak = 0,
    this.streakDays = const [1, 1, 1, 0, 1, 2, 0],
    this.dailyChallenge,
    this.solved = 0,
    this.rank = 0,
    this.accuracy = 0,
    this.continueTopics = const [],
    this.topCoders = const [],
    this.jobs = const [],
  });
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState()) {
    _loadData();
  }

  void _loadData() {
    state = HomeState(
      isLoading: false,
      streak: 15,
      streakDays: [1, 1, 1, 1, 1, 2, 0],
      dailyChallenge: const ProblemModel(
        id: 'daily_1',
        title: 'Two Sum',
        description:
            'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.',
        difficulty: 'Easy',
        tags: ['Array', 'Hash Map'],
        coins: 20,
        xp: 100,
        boilerplate: 'def twoSum(nums, target):\n    # Your code here\n    pass',
        testCases: [
          TestCase(input: '[2,7,11,15]\n9', expectedOutput: '[0,1]'),
          TestCase(input: '[3,2,4]\n6', expectedOutput: '[1,2]'),
        ],
      ),
      solved: 147,
      rank: 42,
      accuracy: 84.5,
      continueTopics: [
        {
          'name': 'Arrays',
          'emoji': '📊',
          'progress': 0.7,
          'color': 0xFF7C3AED,
        },
        {
          'name': 'Trees',
          'emoji': '🌳',
          'progress': 0.4,
          'color': 0xFF10B981,
        },
        {
          'name': 'DP',
          'emoji': '🧠',
          'progress': 0.2,
          'color': 0xFF2563EB,
        },
        {
          'name': 'Graphs',
          'emoji': '🔗',
          'progress': 0.55,
          'color': 0xFFEC4899,
        },
      ],
      topCoders: [
        {
          'name': 'Arjun Verma',
          'college': 'IIT Delhi',
          'xp': 15200,
          'rank': 1,
        },
        {
          'name': 'Priya Singh',
          'college': 'NIT Trichy',
          'xp': 14800,
          'rank': 2,
        },
        {
          'name': 'Rahul Kumar',
          'college': 'BITS Pilani',
          'xp': 13900,
          'rank': 3,
        },
      ],
      jobs: JobModel.sampleJobs,
    );
  }

  void claimStreak() {
    final days = List<int>.from(state.streakDays);
    final todayIdx = days.indexOf(2);
    if (todayIdx >= 0) days[todayIdx] = 1;
    state = HomeState(
      streak: state.streak + 1,
      streakDays: days,
      dailyChallenge: state.dailyChallenge,
      solved: state.solved,
      rank: state.rank,
      accuracy: state.accuracy,
      continueTopics: state.continueTopics,
      topCoders: state.topCoders,
      jobs: state.jobs,
    );
  }
}
