import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/problem_model.dart';
import '../../../core/services/cohere_service.dart';

final practiceNotifierProvider =
    StateNotifierProvider<PracticeNotifier, PracticeState>((ref) {
  return PracticeNotifier();
});

class PracticeState {
  final List<ProblemModel> problems;
  final List<ProblemModel> semanticResults;
  final String selectedFilter;
  final String searchQuery;
  final bool isLoading;
  final bool isSemanticSearch;

  const PracticeState({
    this.problems = const [],
    this.semanticResults = const [],
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.isLoading = false,
    this.isSemanticSearch = false,
  });

  List<ProblemModel> get filteredProblems {
    if (isSemanticSearch && searchQuery.isNotEmpty && semanticResults.isNotEmpty) {
      return semanticResults;
    }

    var filtered = problems;
    if (selectedFilter != 'All') {
      filtered =
          filtered.where((p) => p.difficulty == selectedFilter).toList();
    }
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              p.tags.any((t) =>
                  t.toLowerCase().contains(searchQuery.toLowerCase())))
          .toList();
    }
    return filtered;
  }
}

class PracticeNotifier extends StateNotifier<PracticeState> {
  final _cohere = CohereService();
  
  PracticeNotifier() : super(const PracticeState()) {
    _load();
  }

  void _load() {
    state = PracticeState(
      problems: _sampleProblems,
    );
  }

  void setFilter(String filter) {
    state = PracticeState(
      problems: state.problems,
      semanticResults: state.semanticResults,
      selectedFilter: filter,
      searchQuery: state.searchQuery,
      isSemanticSearch: state.isSemanticSearch,
    );
  }

  void toggleSemanticSearch(bool value) {
    state = PracticeState(
      problems: state.problems,
      semanticResults: state.semanticResults,
      selectedFilter: state.selectedFilter,
      searchQuery: state.searchQuery,
      isSemanticSearch: value,
    );
    if (value && state.searchQuery.isNotEmpty) {
      performSemanticSearch(state.searchQuery);
    }
  }

  Future<void> performSemanticSearch(String query) async {
    if (query.isEmpty) return;

    state = PracticeState(
      problems: state.problems,
      semanticResults: state.semanticResults,
      selectedFilter: state.selectedFilter,
      searchQuery: state.searchQuery,
      isLoading: true,
      isSemanticSearch: state.isSemanticSearch,
    );

    try {
      // 1. Get embedding for the query
      final queryEmbedding = await _cohere.getEmbeddings([query]);
      
      // 2. Get embeddings for all problem titles + descriptions (In prod, these should be pre-computed)
      // Since this is a demo, we simulate the logic by getting them now or using pre-computed ones.
      // For simplicity in this demo, we'll just get them for all problems.
      final problemTexts = state.problems.map((p) => '${p.title}: ${p.description}').toList();
      final problemEmbeddings = await _cohere.getEmbeddings(problemTexts);

      // 3. Calculate similarities
      List<MapEntry<ProblemModel, double>> similarities = [];
      for (int i = 0; i < state.problems.length; i++) {
        final score = _cohere.cosineSimilarity(queryEmbedding[0], problemEmbeddings[i]);
        similarities.add(MapEntry(state.problems[i], score));
      }

      // 4. Sort by similarity
      similarities.sort((a, b) => b.value.compareTo(a.value));

      state = PracticeState(
        problems: state.problems,
        semanticResults: similarities.where((e) => e.value > 0.3).map((e) => e.key).toList(),
        selectedFilter: state.selectedFilter,
        searchQuery: state.searchQuery,
        isLoading: false,
        isSemanticSearch: state.isSemanticSearch,
      );
    } catch (e) {
      state = PracticeState(
        problems: state.problems,
        semanticResults: [],
        selectedFilter: state.selectedFilter,
        searchQuery: state.searchQuery,
        isLoading: false,
        isSemanticSearch: false, // Fallback to normal search
      );
    }
  }

  void setSearch(String query) {
    state = PracticeState(
      problems: state.problems,
      semanticResults: state.semanticResults,
      selectedFilter: state.selectedFilter,
      searchQuery: query,
      isSemanticSearch: state.isSemanticSearch,
    );
    
    if (state.isSemanticSearch && query.isNotEmpty) {
      performSemanticSearch(query);
    }
  }

  @override
  void dispose() {
    _cohere.dispose();
    super.dispose();
  }

  static final _sampleProblems = [
    const ProblemModel(
      id: 'p1', title: 'Two Sum', difficulty: 'Easy',
      description: 'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.',
      tags: ['Array', 'Hash Map'], coins: 10, xp: 50, category: 'Arrays',
      boilerplate: 'def twoSum(nums, target):\n    # Your code here\n    pass',
      testCases: [
        TestCase(input: '[2,7,11,15]\n9', expectedOutput: '[0, 1]'),
      ],
      acceptanceRate: 78.5, solvedCount: 12500,
    ),
    const ProblemModel(
      id: 'p2', title: 'Valid Parentheses', difficulty: 'Easy',
      description: 'Given a string s containing just the characters \'(\', \')\', \'{\', \'}\', \'[\' and \']\', determine if the input string is valid.',
      tags: ['Stack', 'String'], coins: 10, xp: 50, category: 'Stacks',
      boilerplate: 'def isValid(s):\n    # Your code here\n    pass',
      testCases: [
        TestCase(input: '()', expectedOutput: 'True'),
      ],
      acceptanceRate: 72.3, solvedCount: 9800,
    ),
    const ProblemModel(
      id: 'p3', title: 'Merge Two Sorted Lists', difficulty: 'Easy',
      description: 'Merge two sorted linked lists into one sorted list.',
      tags: ['Linked List', 'Recursion'], coins: 15, xp: 60, category: 'Linked List',
      boilerplate: 'def mergeTwoLists(list1, list2):\n    # Your code here\n    pass',
      testCases: [
        TestCase(input: '[1,2,4]\n[1,3,4]', expectedOutput: '[1,1,2,3,4,4]'),
      ],
      acceptanceRate: 68.1, solvedCount: 8200,
    ),
    const ProblemModel(
      id: 'p4', title: 'Maximum Subarray', difficulty: 'Medium',
      description: 'Find the subarray with the largest sum and return its sum.',
      tags: ['Array', 'DP'], coins: 25, xp: 100, category: 'Arrays',
      boilerplate: 'def maxSubArray(nums):\n    # Your code here\n    pass',
      testCases: [
        TestCase(input: '[-2,1,-3,4,-1,2,1,-5,4]', expectedOutput: '6'),
      ],
      acceptanceRate: 55.2, solvedCount: 6500,
    ),
    const ProblemModel(
      id: 'p5', title: 'Longest Common Subsequence', difficulty: 'Medium',
      description: 'Return the length of the longest common subsequence of two strings.',
      tags: ['DP', 'String'], coins: 30, xp: 120, category: 'DP',
      boilerplate: 'def longestCommonSubsequence(text1, text2):\n    # Your code here\n    pass',
      testCases: [
        TestCase(input: 'abcde\nace', expectedOutput: '3'),
      ],
      acceptanceRate: 48.7, solvedCount: 4200,
    ),
    const ProblemModel(
      id: 'p6', title: 'Binary Tree Level Order Traversal', difficulty: 'Medium',
      description: 'Return the level order traversal of a binary tree.',
      tags: ['Tree', 'BFS'], coins: 25, xp: 100, category: 'Trees',
      boilerplate: 'def levelOrder(root):\n    # Your code here\n    pass',
      acceptanceRate: 62.1, solvedCount: 5600,
    ),
    const ProblemModel(
      id: 'p7', title: 'Trapping Rain Water', difficulty: 'Hard',
      description: 'Compute how much water it can trap after raining based on elevation map.',
      tags: ['Array', 'Two Pointers'], coins: 50, xp: 200, category: 'Arrays',
      boilerplate: 'def trap(height):\n    # Your code here\n    pass',
      acceptanceRate: 35.8, solvedCount: 2100,
    ),
    const ProblemModel(
      id: 'p8', title: 'Median of Two Sorted Arrays', difficulty: 'Hard',
      description: 'Return the median of two sorted arrays.',
      tags: ['Array', 'Binary Search'], coins: 60, xp: 250, category: 'Arrays',
      boilerplate: 'def findMedianSortedArrays(nums1, nums2):\n    # Your code here\n    pass',
      acceptanceRate: 28.4, solvedCount: 1500,
    ),
    const ProblemModel(
      id: 'p9', title: 'Reverse Linked List', difficulty: 'Easy',
      description: 'Reverse a singly linked list.',
      tags: ['Linked List'], coins: 10, xp: 50, category: 'Linked List',
      boilerplate: 'def reverseList(head):\n    # Your code here\n    pass',
      acceptanceRate: 82.1, solvedCount: 15600,
    ),
    const ProblemModel(
      id: 'p10', title: 'Word Break', difficulty: 'Medium',
      description: 'Check if a string can be segmented into words from a dictionary.',
      tags: ['DP', 'Hash Map'], coins: 30, xp: 120, category: 'DP',
      boilerplate: 'def wordBreak(s, wordDict):\n    # Your code here\n    pass',
      acceptanceRate: 44.3, solvedCount: 3800,
    ),
  ];
}
