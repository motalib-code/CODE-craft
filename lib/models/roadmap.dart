class RoadmapItem {
  final int priority;
  final String title;
  final String description;
  final int estimatedDays;
  final List<RoadmapResource> resources;
  final String milestone;

  const RoadmapItem({
    required this.priority,
    required this.title,
    required this.description,
    required this.estimatedDays,
    required this.resources,
    required this.milestone,
  });

  factory RoadmapItem.fromJson(Map<String, dynamic> json) {
    return RoadmapItem(
      priority: (json['priority'] ?? 3) as int,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      estimatedDays: (json['estimatedDays'] ?? 0) as int,
      resources: (json['resources'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => RoadmapResource.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      milestone: (json['milestone'] ?? '').toString(),
    );
  }
}

class RoadmapResource {
  final String name;
  final String url;
  final String type;
  final bool isFree;

  const RoadmapResource({
    required this.name,
    required this.url,
    required this.type,
    required this.isFree,
  });

  factory RoadmapResource.fromJson(Map<String, dynamic> json) {
    return RoadmapResource(
      name: (json['name'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      type: (json['type'] ?? 'article').toString(),
      isFree: (json['isFree'] ?? true) as bool,
    );
  }
}

class InProgressItem {
  final String item;
  final int percentDone;
  final String nextStep;

  const InProgressItem({
    required this.item,
    required this.percentDone,
    required this.nextStep,
  });

  factory InProgressItem.fromJson(Map<String, dynamic> json) {
    return InProgressItem(
      item: (json['item'] ?? '').toString(),
      percentDone: (json['percentDone'] ?? 0) as int,
      nextStep: (json['nextStep'] ?? '').toString(),
    );
  }
}

class CompletedItem {
  final String item;
  final String evidence;
  final String completedDate;

  const CompletedItem({
    required this.item,
    required this.evidence,
    required this.completedDate,
  });

  factory CompletedItem.fromJson(Map<String, dynamic> json) {
    return CompletedItem(
      item: (json['item'] ?? '').toString(),
      evidence: (json['evidence'] ?? '').toString(),
      completedDate: (json['completedDate'] ?? '').toString(),
    );
  }
}

class WeeklyPlan {
  final int week;
  final String focus;
  final List<String> tasks;
  final String goal;

  const WeeklyPlan({
    required this.week,
    required this.focus,
    required this.tasks,
    required this.goal,
  });

  factory WeeklyPlan.fromJson(Map<String, dynamic> json) {
    return WeeklyPlan(
      week: (json['week'] ?? 1) as int,
      focus: (json['focus'] ?? '').toString(),
      tasks: (json['tasks'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      goal: (json['goal'] ?? '').toString(),
    );
  }
}

class Milestone {
  final int month;
  final String achievement;
  final List<String> checkItems;

  const Milestone({
    required this.month,
    required this.achievement,
    required this.checkItems,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      month: (json['month'] ?? 1) as int,
      achievement: (json['achievement'] ?? '').toString(),
      checkItems: (json['checkItems'] as List? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class CareerRoadmap {
  final String currentStatus;
  final List<CompletedItem> completedItems;
  final List<InProgressItem> inProgressItems;
  final List<RoadmapItem> todoItems;
  final List<WeeklyPlan> weeklyPlan;
  final List<Milestone> milestones;
  final int jobReadinessScore;
  final String nextImportantAction;

  const CareerRoadmap({
    required this.currentStatus,
    required this.completedItems,
    required this.inProgressItems,
    required this.todoItems,
    required this.weeklyPlan,
    required this.milestones,
    required this.jobReadinessScore,
    required this.nextImportantAction,
  });

  factory CareerRoadmap.fromJson(Map<String, dynamic> json) {
    return CareerRoadmap(
      currentStatus: (json['currentStatus'] ?? '').toString(),
      completedItems: (json['completedItems'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => CompletedItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      inProgressItems: (json['inProgressItems'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => InProgressItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      todoItems: (json['todoItems'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => RoadmapItem.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => a.priority.compareTo(b.priority)),
      weeklyPlan: (json['weeklyPlan'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => WeeklyPlan.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      milestones: (json['milestones'] as List? ?? <dynamic>[])
          .whereType<Map>()
          .map((e) => Milestone.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      jobReadinessScore: (json['jobReadinessScore'] ?? 0) as int,
      nextImportantAction: (json['nextImportantAction'] ?? '').toString(),
    );
  }
}
