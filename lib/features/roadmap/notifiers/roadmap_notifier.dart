import 'package:flutter_riverpod/flutter_riverpod.dart';

final roadmapNotifierProvider =
    StateNotifierProvider<RoadmapNotifier, RoadmapState>((ref) {
  return RoadmapNotifier();
});

class RoadmapState {
  final String selectedTrack;
  final List<RoadmapNode> nodes;
  final bool isLoading;

  const RoadmapState({
    this.selectedTrack = 'DSA',
    this.nodes = const [],
    this.isLoading = false,
  });
}

class RoadmapNode {
  final String id;
  final String title;
  final String emoji;
  final String status; // locked, unlocked, completed
  final int problems;
  final int completed;
  final List<String> subtopics;

  const RoadmapNode({
    required this.id,
    required this.title,
    required this.emoji,
    required this.status,
    this.problems = 0,
    this.completed = 0,
    this.subtopics = const [],
  });
}

class RoadmapNotifier extends StateNotifier<RoadmapState> {
  RoadmapNotifier() : super(const RoadmapState()) {
    _load();
  }

  void _load() {
    state = const RoadmapState(
      selectedTrack: 'DSA',
      nodes: [
        RoadmapNode(id: 'arrays', title: 'Arrays', emoji: '📊', status: 'completed', problems: 30, completed: 30, subtopics: ['1D Arrays', '2D Arrays', 'Sliding Window', 'Prefix Sum']),
        RoadmapNode(id: 'strings', title: 'Strings', emoji: '🔤', status: 'completed', problems: 25, completed: 25, subtopics: ['Pattern Matching', 'Anagrams', 'Palindrome']),
        RoadmapNode(id: 'linked_list', title: 'Linked List', emoji: '🔗', status: 'completed', problems: 20, completed: 18, subtopics: ['Singly LL', 'Doubly LL', 'Circular LL']),
        RoadmapNode(id: 'stacks', title: 'Stacks & Queues', emoji: '📚', status: 'unlocked', problems: 22, completed: 10, subtopics: ['Stack Basics', 'Monotonic Stack', 'Queue', 'Deque']),
        RoadmapNode(id: 'trees', title: 'Trees', emoji: '🌳', status: 'unlocked', problems: 35, completed: 5, subtopics: ['Binary Tree', 'BST', 'AVL', 'Segment Tree']),
        RoadmapNode(id: 'graphs', title: 'Graphs', emoji: '🕸️', status: 'locked', problems: 40, completed: 0, subtopics: ['BFS', 'DFS', 'Dijkstra', 'Topological Sort']),
        RoadmapNode(id: 'dp', title: 'Dynamic Programming', emoji: '🧠', status: 'locked', problems: 50, completed: 0, subtopics: ['1D DP', '2D DP', 'Knapsack', 'LCS']),
        RoadmapNode(id: 'greedy', title: 'Greedy', emoji: '🎯', status: 'locked', problems: 20, completed: 0, subtopics: ['Activity Selection', 'Huffman', 'Job Scheduling']),
        RoadmapNode(id: 'bit', title: 'Bit Manipulation', emoji: '⚡', status: 'locked', problems: 15, completed: 0, subtopics: ['XOR Tricks', 'Bitmask DP', 'Power of 2']),
      ],
    );
  }

  void selectTrack(String track) {
    state = RoadmapState(
      selectedTrack: track,
      nodes: state.nodes,
    );
  }

  void loadRoadmap(String roadmapName) {
    // In a real app, this would fetch from an API or local JSON
    // For now, we'll simulate loading by updating the selected track and resetting nodes
    state = RoadmapState(
      selectedTrack: roadmapName,
      nodes: state.nodes, // Keeping existing nodes for demo purposes
      isLoading: false,
    );
  }
}
