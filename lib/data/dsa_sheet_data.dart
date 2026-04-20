import '../models/company.dart';

const String _drive =
    'https://drive.google.com/drive/folders/1NlbJI1MAfb4UfL5h5AoaeO6-UlA3hF22';
const String _playbook = 'https://roadmap.swadhin.cv';
const String _gh =
    'https://github.com/snehasishroy/leetcode-companywise-interview-questions/tree/main';

CompanyDSA _d(String c, String slug, String t) => CompanyDSA(
      company: c,
      driveUrl: _drive,
      tricks: t,
      githubUrl: '$_gh/$slug',
      faangPlaybookUrl: _playbook,
    );

final List<CompanyDSA> dsaProblemsSheet = [
  _d('Google', 'google', 'Focus on backtracking and dynamic programming.'),
  _d('Microsoft', 'microsoft', 'Practice binary search, greedy algorithms.'),
  _d('Amazon', 'amazon', 'Work on sliding window, heap, and DFS/BFS.'),
  _d('Meta/Facebook', 'meta', 'Master recursion, graphs, and bit manipulation.'),
  _d('Apple', 'apple', 'Prioritize dynamic programming and divide and conquer.'),
  _d('Adobe', 'adobe', 'Practice sorting and searching techniques.'),
  _d('Goldman Sachs', 'goldman-sachs', 'Focus on arrays, hashing, and string manipulation.'),
  _d('Uber', 'uber', 'Work on graphs, BFS/DFS, and Dijkstra algorithm.'),
  _d('LinkedIn', 'linkedin', 'Focus on two-pointer and sliding window techniques.'),
  _d('Netflix', 'netflix', 'Prioritize dynamic programming and DP on trees.'),
  _d('Twitter', 'twitter', 'Work on greedy algorithms and interval problems.'),
  _d('Dropbox', 'dropbox', 'Master recursion and binary search on sorted arrays.'),
  _d('Airbnb', 'airbnb', 'Practice graph traversal and backtracking.'),
  _d('Salesforce', 'salesforce', 'Work on greedy algorithms and dynamic programming.'),
  _d('Oracle', 'oracle', 'Focus on matrix traversal and dynamic programming.'),
  _d('PayPal', 'paypal', 'Prioritize binary search and sorting problems.'),
  _d('Walmart', 'walmart', 'Focus on hashing, prefix sums, and arrays.'),
  _d('Expedia', 'expedia', 'Practice stack-based problems and recursion.'),
  _d('Snap', 'snapchat', 'Focus on graphs and dynamic programming.'),
  _d('Yahoo', 'yahoo', 'Work on linked lists and recursion.'),
  _d('DoorDash', 'doordash', 'Master binary trees and backtracking.'),
  _d('Stripe', 'stripe', 'Practice greedy algorithms and string manipulation.'),
  _d('Lyft', 'lyft', 'Focus on two-pointer and sliding window techniques.'),
  _d('Intuit', 'intuit', 'Work on backtracking and dynamic programming.'),
  _d('IBM', 'ibm', 'Master dynamic programming and recursion problems.'),
  _d('Atlassian', 'atlassian', 'Focus on graph traversal and dynamic programming.'),
  _d('Reddit', 'reddit', 'Work on hashing and bit manipulation.'),
  _d('Pinterest', 'pinterest', 'Master recursion and divide and conquer techniques.'),
  _d('Spotify', 'spotify', 'Focus on sorting, searching, and heaps.'),
  _d('Bloomberg', 'bloomberg', 'Work on arrays, dynamic programming, and graphs.'),
  _d('Cisco', 'cisco', 'Focus on linked lists and dynamic programming.'),
  _d('ByteDance', 'bytedance', 'Master sorting algorithms and binary search.'),
  _d('Tesla', 'tesla', 'Work on graph traversal and dynamic programming.'),
  _d('TikTok', 'tiktok', 'Prioritize dynamic programming and recursion.'),
  _d('Nvidia', 'nvidia', 'Practice bit manipulation and backtracking.'),
];
