class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final String category;
  final int requiredXp;
  final bool earned;
  final DateTime? earnedAt;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    this.category = 'General',
    this.requiredXp = 0,
    this.earned = false,
    this.earnedAt,
  });

  factory BadgeModel.fromMap(Map<String, dynamic> map) => BadgeModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        emoji: map['emoji'] ?? '🏆',
        category: map['category'] ?? 'General',
        requiredXp: map['requiredXp'] ?? 0,
        earned: map['earned'] ?? false,
        earnedAt: map['earnedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['earnedAt'])
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'emoji': emoji,
        'category': category,
        'requiredXp': requiredXp,
        'earned': earned,
        'earnedAt': earnedAt?.millisecondsSinceEpoch,
      };

  static List<BadgeModel> get allBadges => [
        const BadgeModel(
            id: 'first_code',
            title: 'First Code',
            description: 'Wrote your first line of code',
            emoji: '👶',
            requiredXp: 0),
        const BadgeModel(
            id: 'streak_7',
            title: '7-Day Streak',
            description: 'Maintained 7-day coding streak',
            emoji: '🔥',
            requiredXp: 100),
        const BadgeModel(
            id: 'streak_30',
            title: '30-Day Streak',
            description: 'Maintained 30-day coding streak',
            emoji: '⚡',
            requiredXp: 500),
        const BadgeModel(
            id: 'easy_10',
            title: 'Easy 10',
            description: 'Solved 10 easy problems',
            emoji: '🌱',
            requiredXp: 200),
        const BadgeModel(
            id: 'medium_10',
            title: 'Medium 10',
            description: 'Solved 10 medium problems',
            emoji: '🎯',
            requiredXp: 500),
        const BadgeModel(
            id: 'hard_5',
            title: 'Hard 5',
            description: 'Solved 5 hard problems',
            emoji: '💪',
            requiredXp: 1000),
        const BadgeModel(
            id: 'binary_conqueror',
            title: 'Binary Conqueror',
            description: 'Solved 50+ hard-level problems on binary',
            emoji: '🏆',
            requiredXp: 2000),
        const BadgeModel(
            id: 'elite_coder',
            title: 'Elite Coder',
            description: 'Ranked top 1% in summer challenge',
            emoji: '👑',
            requiredXp: 5000),
        const BadgeModel(
            id: 'lead_mentor',
            title: 'Lead Mentor',
            description: 'Helped 200+ students in Flutter peer group',
            emoji: '🎓',
            requiredXp: 3000),
        const BadgeModel(
            id: 'project_master',
            title: 'Project Master',
            description: 'Completed 5 projects',
            emoji: '🚀',
            requiredXp: 1500),
        const BadgeModel(
            id: 'interview_ready',
            title: 'Interview Ready',
            description: 'Scored A in mock interview',
            emoji: '💼',
            requiredXp: 2500),
        const BadgeModel(
            id: 'bug_hunter',
            title: 'Bug Hunter',
            description: 'Used AI debugger 20 times',
            emoji: '🐛',
            requiredXp: 300),
      ];
}
