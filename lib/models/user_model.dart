class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? college;
  final String? year;
  final String? level;
  final String? githubUsername;
  final int coins;
  final int xp;
  final int streak;
  final int problemsSolved;
  final int rank;
  final List<String> earnedBadges;
  final List<String> completedTopics;
  final DateTime? createdAt;
  final DateTime? lastActive;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.college,
    this.year,
    this.level,
    this.githubUsername,
    this.coins = 0,
    this.xp = 0,
    this.streak = 0,
    this.problemsSolved = 0,
    this.rank = 0,
    this.earnedBadges = const [],
    this.completedTopics = const [],
    this.createdAt,
    this.lastActive,
  });

  int get currentLevel => (xp / 1000).floor() + 1;
  double get levelProgress => (xp % 1000) / 1000;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      college: map['college'],
      year: map['year'],
      level: map['level'],
      githubUsername: map['githubUsername'],
      coins: map['coins'] ?? 0,
      xp: map['xp'] ?? 0,
      streak: map['streak'] ?? 0,
      problemsSolved: map['problemsSolved'] ?? 0,
      rank: map['rank'] ?? 0,
      earnedBadges: List<String>.from(map['earnedBadges'] ?? []),
      completedTopics: List<String>.from(map['completedTopics'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      lastActive: map['lastActive'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastActive'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'college': college,
        'year': year,
        'level': level,
        'githubUsername': githubUsername,
        'coins': coins,
        'xp': xp,
        'streak': streak,
        'problemsSolved': problemsSolved,
        'rank': rank,
        'earnedBadges': earnedBadges,
        'completedTopics': completedTopics,
        'createdAt': createdAt?.millisecondsSinceEpoch,
        'lastActive': lastActive?.millisecondsSinceEpoch,
      };

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? college,
    String? year,
    String? level,
    String? githubUsername,
    int? coins,
    int? xp,
    int? streak,
    int? problemsSolved,
    int? rank,
    List<String>? earnedBadges,
    List<String>? completedTopics,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      college: college ?? this.college,
      year: year ?? this.year,
      level: level ?? this.level,
      githubUsername: githubUsername ?? this.githubUsername,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      problemsSolved: problemsSolved ?? this.problemsSolved,
      rank: rank ?? this.rank,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      completedTopics: completedTopics ?? this.completedTopics,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
