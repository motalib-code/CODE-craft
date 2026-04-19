import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/leetcode_problem.dart';
import '../../services/leetcode_service.dart';

class ProblemsNotifier extends StateNotifier<List<LeetCodeProblem>> {
  ProblemsNotifier() : super([]);

  final _service = LeetCodeService();

  Future<void> fetchProblems({
    int limit = 50,
    int offset = 0,
    String difficulty = '',
  }) async {
    try {
      final problems = await _service.fetchProblems(
        limit: limit,
        offset: offset,
        difficulty: difficulty,
      );
      state = problems;
    } catch (e) {
      print('Error fetching problems: $e');
    }
  }

  Future<void> searchProblems(String query) async {
    try {
      if (query.isEmpty) {
        await fetchProblems();
        return;
      }
      final results = await _service.searchProblems(query);
      state = results;
    } catch (e) {
      print('Error searching problems: $e');
    }
  }

  List<LeetCodeProblem> filterByDifficulty(String difficulty) {
    if (difficulty == 'All') return state;
    return state.where((p) => p.difficulty == difficulty).toList();
  }

  List<LeetCodeProblem> filterByTag(String tag) {
    return state.where((p) => p.tags.contains(tag)).toList();
  }

  List<LeetCodeProblem> get allProblems => state;
  List<LeetCodeProblem> get easyProblems => filterByDifficulty('Easy');
  List<LeetCodeProblem> get mediumProblems => filterByDifficulty('Medium');
  List<LeetCodeProblem> get hardProblems => filterByDifficulty('Hard');
}

final problemsProvider =
    StateNotifierProvider<ProblemsNotifier, List<LeetCodeProblem>>(
  (ref) => ProblemsNotifier(),
);

// Filter state
final difficultyFilterProvider = StateProvider<String>((ref) => 'All');
final searchQueryProvider = StateProvider<String>((ref) => '');

// Category selection
final categoryProvider = StateProvider<String>((ref) => 'Coding Practice');

// Filtered problems based on search and difficulty
final filteredProblemsProvider = Provider<List<LeetCodeProblem>>((ref) {
  final problems = ref.watch(problemsProvider);
  final difficulty = ref.watch(difficultyFilterProvider);
  final query = ref.watch(searchQueryProvider);

  var filtered = problems;

  // Filter by difficulty
  if (difficulty != 'All') {
    filtered = filtered.where((p) => p.difficulty == difficulty).toList();
  }

  // Filter by search query
  if (query.isNotEmpty) {
    filtered = filtered
        .where((p) =>
            p.title.toLowerCase().contains(query.toLowerCase()) ||
            p.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  return filtered;
});
