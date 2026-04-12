import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/project_model.dart';

final projectsNotifierProvider =
    StateNotifierProvider<ProjectsNotifier, ProjectsState>((ref) {
  return ProjectsNotifier();
});

class ProjectsState {
  final List<ProjectModel> projects;
  final bool isLoading;

  const ProjectsState({this.projects = const [], this.isLoading = false});
}

class ProjectsNotifier extends StateNotifier<ProjectsState> {
  ProjectsNotifier() : super(const ProjectsState()) {
    _load();
  }

  void _load() {
    state = const ProjectsState(
      projects: [
        ProjectModel(
          id: 'pr1', title: 'Weather App', description: 'Build a beautiful weather app using Flutter and OpenWeatherMap API',
          difficulty: 'Easy', techStack: ['Flutter', 'Dart', 'API'], coins: 100, xp: 500, estimatedHours: 4,
          steps: [
            ProjectStep(order: 1, title: 'Setup Project', description: 'Create Flutter project and add dependencies'),
            ProjectStep(order: 2, title: 'Design UI', description: 'Build the main weather display screen'),
            ProjectStep(order: 3, title: 'API Integration', description: 'Connect to OpenWeatherMap API'),
            ProjectStep(order: 4, title: 'Polish', description: 'Add animations and error handling'),
          ],
        ),
        ProjectModel(
          id: 'pr2', title: 'Todo App with Firebase', description: 'Full-stack todo app with authentication and realtime sync',
          difficulty: 'Medium', techStack: ['Flutter', 'Firebase', 'Firestore'], coins: 200, xp: 1000, estimatedHours: 8,
          steps: [
            ProjectStep(order: 1, title: 'Firebase Setup', description: 'Configure Firebase project'),
            ProjectStep(order: 2, title: 'Auth Flow', description: 'Implement login/signup'),
            ProjectStep(order: 3, title: 'CRUD Operations', description: 'Add, edit, delete todos'),
            ProjectStep(order: 4, title: 'Realtime Sync', description: 'Enable realtime updates'),
          ],
        ),
        ProjectModel(
          id: 'pr3', title: 'E-Commerce UI', description: 'Clone a professional e-commerce app UI with cart and checkout',
          difficulty: 'Medium', techStack: ['Flutter', 'Dart', 'Provider'], coins: 250, xp: 1200, estimatedHours: 10,
          steps: [
            ProjectStep(order: 1, title: 'Home Screen', description: 'Product grid with categories'),
            ProjectStep(order: 2, title: 'Product Detail', description: 'Full product detail page'),
            ProjectStep(order: 3, title: 'Cart', description: 'Shopping cart with quantity management'),
            ProjectStep(order: 4, title: 'Checkout', description: 'Checkout flow with payment UI'),
          ],
        ),
        ProjectModel(
          id: 'pr4', title: 'Chat App', description: 'Build a real-time messaging app with Firebase',
          difficulty: 'Hard', techStack: ['Flutter', 'Firebase', 'FCM'], coins: 400, xp: 2000, estimatedHours: 15,
          steps: [
            ProjectStep(order: 1, title: 'Auth & Profile', description: 'User authentication and profile setup'),
            ProjectStep(order: 2, title: 'Chat UI', description: 'Build chat interface'),
            ProjectStep(order: 3, title: 'Messaging', description: 'Real-time message sending and receiving'),
            ProjectStep(order: 4, title: 'Push Notifications', description: 'Add push notification support'),
          ],
        ),
      ],
    );
  }
}
