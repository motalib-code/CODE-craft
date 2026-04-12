class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<String> techStack;
  final String category;
  final int coins;
  final int xp;
  final String? thumbnailUrl;
  final List<ProjectStep> steps;
  final int estimatedHours;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    this.techStack = const [],
    this.category = 'General',
    this.coins = 100,
    this.xp = 500,
    this.thumbnailUrl,
    this.steps = const [],
    this.estimatedHours = 5,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      difficulty: map['difficulty'] ?? 'Easy',
      techStack: List<String>.from(map['techStack'] ?? []),
      category: map['category'] ?? 'General',
      coins: map['coins'] ?? 100,
      xp: map['xp'] ?? 500,
      thumbnailUrl: map['thumbnailUrl'],
      steps: (map['steps'] as List?)
              ?.map((s) => ProjectStep.fromMap(s))
              .toList() ??
          [],
      estimatedHours: map['estimatedHours'] ?? 5,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'techStack': techStack,
        'category': category,
        'coins': coins,
        'xp': xp,
        'thumbnailUrl': thumbnailUrl,
        'steps': steps.map((s) => s.toMap()).toList(),
        'estimatedHours': estimatedHours,
      };
}

class ProjectStep {
  final int order;
  final String title;
  final String description;
  final bool completed;

  const ProjectStep({
    required this.order,
    required this.title,
    required this.description,
    this.completed = false,
  });

  factory ProjectStep.fromMap(Map<String, dynamic> map) => ProjectStep(
        order: map['order'] ?? 0,
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        completed: map['completed'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'order': order,
        'title': title,
        'description': description,
        'completed': completed,
      };
}
