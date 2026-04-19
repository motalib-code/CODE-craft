class AlgoTopic {
  final String name;
  final String icon;
  final List<String> subtopics;
  final String gfgUrl;

  AlgoTopic({
    required this.name,
    required this.icon,
    required this.subtopics,
    required this.gfgUrl,
  });
}

class DSTopic {
  final String name;
  final String icon;
  final List<String> problems;
  final String gfgUrl;

  DSTopic({
    required this.name,
    required this.icon,
    required this.problems,
    required this.gfgUrl,
  });
}

final List<AlgoTopic> algorithmTopics = [
  AlgoTopic(
    name: 'Sorting',
    icon: '🔢',
    subtopics: [
      'Bubble Sort',
      'Selection Sort',
      'Insertion Sort',
      'Merge Sort',
      'Quick Sort',
      'Heap Sort',
      'Counting Sort'
    ],
    gfgUrl: 'https://www.geeksforgeeks.org/sorting-algorithms/',
  ),
  AlgoTopic(
    name: 'Searching',
    icon: '🔍',
    subtopics: [
      'Linear Search',
      'Binary Search',
      'Ternary Search',
      'Jump Search',
      'Exponential Search'
    ],
    gfgUrl: 'https://www.geeksforgeeks.org/searching-algorithms/',
  ),
  AlgoTopic(
    name: 'Dynamic Programming',
    icon: '🧩',
    subtopics: ['Memoization', 'Tabulation', 'Fibonacci', 'LCS', 'LIS', 'Knapsack', 'Coin Change'],
    gfgUrl: 'https://www.geeksforgeeks.org/dynamic-programming/',
  ),
  AlgoTopic(
    name: 'Greedy',
    icon: '🎯',
    subtopics: ['Activity Selection', 'Fractional Knapsack', 'Job Scheduling', 'Huffman Coding'],
    gfgUrl: 'https://www.geeksforgeeks.org/greedy-algorithms/',
  ),
  AlgoTopic(
    name: 'Backtracking',
    icon: '↩️',
    subtopics: ['N-Queens', 'Sudoku Solver', 'Rat in Maze', 'Subset Sum', 'Permutations'],
    gfgUrl: 'https://www.geeksforgeeks.org/backtracking-algorithms/',
  ),
  AlgoTopic(
    name: 'Graph Algorithms',
    icon: '🕸️',
    subtopics: ['BFS', 'DFS', 'Dijkstra', 'Bellman Ford', 'Floyd Warshall', 'Kruskal', 'Prim'],
    gfgUrl: 'https://www.geeksforgeeks.org/graph-data-structure-and-algorithms/',
  ),
  AlgoTopic(
    name: 'Divide & Conquer',
    icon: '✂️',
    subtopics: ['Binary Search', 'Merge Sort', 'Quick Sort', 'Strassen Matrix', 'Closest Pair'],
    gfgUrl: 'https://www.geeksforgeeks.org/divide-and-conquer/',
  ),
  AlgoTopic(
    name: 'Bit Manipulation',
    icon: '⚙️',
    subtopics: ['AND OR XOR', 'Set/Clear bit', 'Count set bits', 'Power of 2', 'Single Number'],
    gfgUrl: 'https://www.geeksforgeeks.org/bitwise-algorithms/',
  ),
];

final List<DSTopic> dataStructureTopics = [
  DSTopic(
    name: 'Arrays',
    icon: '📊',
    problems: ['Two Sum', 'Max Subarray', 'Rotate Array', 'Find Duplicates'],
    gfgUrl: 'https://www.geeksforgeeks.org/array-data-structure/',
  ),
  DSTopic(
    name: 'Linked List',
    icon: '🔗',
    problems: ['Reverse LL', 'Detect Cycle', 'Merge Two Sorted', 'Find Middle'],
    gfgUrl: 'https://www.geeksforgeeks.org/data-structures/linked-list/',
  ),
  DSTopic(
    name: 'Stack',
    icon: '📚',
    problems: ['Valid Parentheses', 'Min Stack', 'Daily Temperatures', 'Next Greater'],
    gfgUrl: 'https://www.geeksforgeeks.org/stack-data-structure/',
  ),
  DSTopic(
    name: 'Queue',
    icon: '🚶',
    problems: ['Sliding Window Max', 'BFS', 'Circular Queue', 'LRU Cache'],
    gfgUrl: 'https://www.geeksforgeeks.org/queue-data-structure/',
  ),
  DSTopic(
    name: 'Binary Tree',
    icon: '🌳',
    problems: ['Inorder', 'Level Order', 'Height', 'Diameter', 'LCA'],
    gfgUrl: 'https://www.geeksforgeeks.org/binary-tree-data-structure/',
  ),
  DSTopic(
    name: 'Binary Search Tree',
    icon: '🌲',
    problems: ['Insert', 'Delete', 'Search', 'Kth Smallest', 'Validate BST'],
    gfgUrl: 'https://www.geeksforgeeks.org/binary-search-tree-data-structure/',
  ),
  DSTopic(
    name: 'Heap',
    icon: '⛰️',
    problems: ['Kth Largest', 'Merge K Lists', 'Top K Elements', 'Median Stream'],
    gfgUrl: 'https://www.geeksforgeeks.org/heap-data-structure/',
  ),
  DSTopic(
    name: 'Hash Map',
    icon: '🗂️',
    problems: ['Two Sum', 'Group Anagrams', 'Top K Frequent', 'Valid Anagram'],
    gfgUrl: 'https://www.geeksforgeeks.org/hashing-data-structure/',
  ),
  DSTopic(
    name: 'Graph',
    icon: '🕸️',
    problems: ['Number of Islands', 'Clone Graph', 'Course Schedule', 'Bipartite'],
    gfgUrl: 'https://www.geeksforgeeks.org/graph-data-structure-and-algorithms/',
  ),
  DSTopic(
    name: 'Trie',
    icon: '🔤',
    problems: ['Implement Trie', 'Word Search II', 'Replace Words'],
    gfgUrl: 'https://www.geeksforgeeks.org/trie-insert-and-search/',
  ),
];
