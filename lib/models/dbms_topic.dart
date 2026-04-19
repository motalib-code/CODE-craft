class SQLProblem {
  final String title;
  final String difficulty;
  final String leetcodeSlug;

  SQLProblem({
    required this.title,
    required this.difficulty,
    required this.leetcodeSlug,
  });
}

class DBMSTopic {
  final String name;
  final String icon;
  final List<String> concepts;
  final List<SQLProblem> sqlProblems;
  final String gfgUrl;

  DBMSTopic({
    required this.name,
    required this.icon,
    required this.concepts,
    required this.sqlProblems,
    required this.gfgUrl,
  });
}

final List<DBMSTopic> dbmsTopics = [
  DBMSTopic(
    name: 'SQL Basics',
    icon: '📋',
    concepts: ['SELECT', 'WHERE', 'ORDER BY', 'GROUP BY', 'HAVING', 'LIMIT'],
    sqlProblems: [
      SQLProblem(
        title: 'Find Second Highest Salary',
        difficulty: 'Medium',
        leetcodeSlug: 'second-highest-salary',
      ),
      SQLProblem(
        title: 'Department Top Salaries',
        difficulty: 'Hard',
        leetcodeSlug: 'department-top-three-salaries',
      ),
      SQLProblem(
        title: 'Consecutive Numbers',
        difficulty: 'Medium',
        leetcodeSlug: 'consecutive-numbers',
      ),
      SQLProblem(
        title: 'Employees Earning More',
        difficulty: 'Easy',
        leetcodeSlug: 'employees-earning-more-than-their-managers',
      ),
    ],
    gfgUrl: 'https://www.geeksforgeeks.org/sql-tutorial/',
  ),
  DBMSTopic(
    name: 'JOINS',
    icon: '🔄',
    concepts: ['INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL JOIN', 'CROSS JOIN', 'SELF JOIN'],
    sqlProblems: [
      SQLProblem(
        title: 'Combine Two Tables',
        difficulty: 'Easy',
        leetcodeSlug: 'combine-two-tables',
      ),
      SQLProblem(
        title: 'Customers Who Never Order',
        difficulty: 'Easy',
        leetcodeSlug: 'customers-who-never-order',
      ),
    ],
    gfgUrl: 'https://www.geeksforgeeks.org/sql-join-set-1-inner-left-right-and-full-joins/',
  ),
  DBMSTopic(
    name: 'Normalization',
    icon: '📐',
    concepts: ['1NF', '2NF', '3NF', 'BCNF', 'Functional Dependency', 'Decomposition'],
    sqlProblems: [],
    gfgUrl: 'https://www.geeksforgeeks.org/normalization-in-dbms/',
  ),
  DBMSTopic(
    name: 'Transactions & ACID',
    icon: '🔒',
    concepts: [
      'Atomicity',
      'Consistency',
      'Isolation',
      'Durability',
      'Deadlock',
      'Concurrency Control'
    ],
    sqlProblems: [],
    gfgUrl: 'https://www.geeksforgeeks.org/acid-properties-in-dbms/',
  ),
  DBMSTopic(
    name: 'Indexing',
    icon: '📇',
    concepts: [
      'B-Tree Index',
      'Hash Index',
      'Clustered',
      'Non-Clustered',
      'Composite Index',
      'Query Optimization'
    ],
    sqlProblems: [],
    gfgUrl: 'https://www.geeksforgeeks.org/indexing-in-databases-set-1/',
  ),
];
