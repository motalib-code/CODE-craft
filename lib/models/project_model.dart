import 'package:flutter/material.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String owner;
  final String repoName;
  final String readmeUrl;
  final List<String> tags;
  final String sector;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.repoName,
    required this.readmeUrl,
    required this.tags,
    required this.sector,
  });

  String get githubUrl => 'https://github.com/$owner/$repoName';
}

class ProjectCategory {
  final String id;
  final String name;
  final String title;
  final String description;
  final String? repoUrl;
  final List<String>? tags;
  final List<ProjectItem> projects;
  final int? projectCount;
  final bool hasSubcategories;

  const ProjectCategory({
    required this.id,
    required this.name,
    this.title = '',
    required this.description,
    this.repoUrl,
    this.tags,
    required this.projects,
    this.projectCount,
    this.hasSubcategories = false,
  });
}

class ProjectItem {
  final int number;
  final String name;
  final String? demoUrl;
  final String? githubUrl;
  final String? youtubeUrl;
  final String? industry;
  final String? description;
  final String? actionLabel;

  const ProjectItem({
    required this.number,
    required this.name,
    this.demoUrl,
    this.githubUrl,
    this.youtubeUrl,
    this.industry,
    this.description,
    this.actionLabel,
  });

  /// Get the primary action URL (priority: youtube > demo > github)
  String? get primaryUrl => youtubeUrl ?? demoUrl ?? githubUrl;

  /// Get the action button label based on available URLs
  String get actionButtonLabel {
    if (actionLabel != null) return actionLabel!;
    if (youtubeUrl != null) return 'Watch';
    if (demoUrl != null) return 'Live Demo';
    if (githubUrl != null) return 'GitHub';
    return 'View';
  }

  /// Get the action icon
  IconData get actionIcon {
    if (youtubeUrl != null) return Icons.play_circle_outline;
    if (demoUrl != null) return Icons.language;
    if (githubUrl != null) return Icons.code;
    return Icons.link;
  }
}

/// Represents a subcategory within a main category (for C++ DSA)
class ProjectSubcategory {
  final String title;
  final int totalProjects;
  final List<ProjectItem> projects;

  const ProjectSubcategory({
    required this.title,
    required this.totalProjects,
    required this.projects,
  });
}

