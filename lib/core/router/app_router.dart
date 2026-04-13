import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/notifiers/auth_notifier.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/roadmap/screens/roadmap_screen.dart';
import '../../features/roadmap/screens/topic_detail_screen.dart';
import '../../features/roadmap/screens/syllabus_parser_screen.dart';
import '../../features/roadmap/screens/roadmap_explorer_screen.dart';
import '../../features/practice/screens/practice_screen.dart';
import '../../features/practice/screens/code_editor_screen.dart';
import '../../features/projects/screens/projects_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/resume_screen.dart';
import '../../features/profile/screens/swag_store_screen.dart';
import '../../features/profile/screens/mock_interview_screen.dart';
import '../../features/ai_mentor/screens/ai_chat_screen.dart';
import '../../features/ai_mentor/screens/camera_scanner_screen.dart';
import '../../features/gamification/screens/leaderboard_screen.dart';
import '../../features/gamification/screens/badges_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import '../constants/app_colors.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final user = authState.value;
      final isLoggedIn = user != null;
      final isOnAuth = state.matchedLocation.startsWith('/auth');

      // ✅ Guest mode - skip kiya toh home jaane do
      final isGuest = ref.read(authNotifierProvider).isGuest;
      if (isGuest) return null;

      if (state.matchedLocation == '/splash') return null;

      if (!isLoggedIn && !isOnAuth) return '/auth/login';
      if (isLoggedIn && isOnAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainNavShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/roadmap',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RoadmapScreen(),
            ),
          ),
          GoRoute(
            path: '/practice',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PracticeScreen(),
            ),
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProjectsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (context, state) => const AiChatScreen(),
      ),
      GoRoute(
        path: '/code-editor/:problemId',
        builder: (context, state) => CodeEditorScreen(
          problemId: state.pathParameters['problemId']!,
        ),
      ),
      GoRoute(
        path: '/topic/:topicName',
        builder: (context, state) => TopicDetailScreen(
          topicName: state.pathParameters['topicName']!,
        ),
      ),
      GoRoute(
        path: '/roadmap/syllabus-parser',
        builder: (context, state) => const SyllabusParserScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/badges',
        builder: (context, state) => const BadgesScreen(),
      ),
      GoRoute(
        path: '/store',
        builder: (context, state) => const SwagStoreScreen(),
      ),
      GoRoute(
        path: '/mock-interview',
        builder: (context, state) => const MockInterviewScreen(),
      ),
      GoRoute(
        path: '/resume',
        builder: (context, state) => const ResumeScreen(),
      ),
      GoRoute(
        path: '/roadmap/explorer',
        builder: (context, state) => const RoadmapExplorerScreen(),
      ),
      GoRoute(
        path: '/camera-scanner',
        builder: (context, state) => const CameraScannerScreen(),
      ),
    ],
  );
});

class MainNavShell extends StatefulWidget {
  final Widget child;
  const MainNavShell({super.key, required this.child});

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  int _currentIndex = 0;

  static const _routes = ['/home', '/roadmap', '/practice', '/projects', '/profile'];

  @override
  Widget build(BuildContext context) {
    // Sync index with current route
    final location = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexOf(location);
    if (index >= 0 && index != _currentIndex) {
      _currentIndex = index;
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: widget.child,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          context.go(_routes[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.purple,
        onPressed: () => context.push('/ai-chat'),
        child: const Icon(Icons.auto_awesome, color: Colors.white),
      ),
    );
  }
}
