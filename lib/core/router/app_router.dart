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
import '../../features/practice/screens/problem_detail_screen.dart';
import '../../screens/projects_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/resume_screen.dart';
import '../../features/profile/screens/swag_store_screen.dart';
import '../../features/profile/screens/mock_interview_screen.dart';
import '../../features/profile/screens/company_research_screen.dart';
import '../../features/ai_mentor/screens/ai_chat_screen.dart';
import '../../features/ai_mentor/screens/camera_scanner_screen.dart';
import '../../features/gamification/screens/leaderboard_screen.dart';
import '../../features/gamification/screens/badges_screen.dart';
import '../../features/image_generator/screens/image_generator_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/offline/screens/offline_sync_screen.dart';
import '../../screens/career_assistant_shell_screen.dart';
import '../../screens/resume_checker_screen.dart';
import '../../screens/mock_interview_setup_screen.dart';
import '../../screens/jobs_screen.dart';
import '../../screens/news_screen.dart';
import '../../screens/smart_insights_screen.dart';
import '../../screens/leaderboard_screen.dart' as hackathon_leaderboard;
import '../../screens/placement_predictor_screen.dart';
import '../../screens/peer_interview_screen.dart';
import '../../screens/college_dashboard_screen.dart';
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
          GoRoute(
            path: '/mock-interview-setup',
            builder: (context, state) => const MockInterviewSetupScreen(),
          ),
          GoRoute(
            path: '/jobs',
            builder: (context, state) => const JobsScreen(),
          ),
          GoRoute(
            path: '/news',
            builder: (context, state) => const NewsScreen(),
          ),
          GoRoute(
            path: '/insights',
            builder: (context, state) => const SmartInsightsScreen(),
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
        path: '/practice/problem/:slug',
        builder: (context, state) => ProblemDetailScreen(
          problemSlug: state.pathParameters['slug']!,
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
        path: '/company-research',
        builder: (context, state) => const CompanyResearchScreen(),
      ),
      GoRoute(
        path: '/roadmap/explorer',
        builder: (context, state) => const RoadmapExplorerScreen(),
      ),
      GoRoute(
        path: '/camera-scanner',
        builder: (context, state) => const CameraScannerScreen(),
      ),
      GoRoute(
        path: '/image-generator',
        builder: (context, state) => const ImageGeneratorScreen(),
      ),
      GoRoute(
        path: '/community',
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: '/offline',
        builder: (context, state) => const OfflineSyncScreen(),
      ),
      GoRoute(
        path: '/career-assistant',
        builder: (context, state) => const CareerAssistantShellScreen(),
      ),
      GoRoute(
        path: '/resume-checker',
        builder: (context, state) => const ResumeCheckerScreen(),
      ),
      // Hackathon Features Routes
      GoRoute(
        path: '/hackathon/leaderboard/:collegeCode',
        builder: (context, state) => hackathon_leaderboard.LeaderboardScreen(
          userCollegeCode: state.pathParameters['collegeCode'] ?? 'DEFAULT',
          currentUserId: 'user123', // TODO: Get from auth provider
        ),
      ),
      GoRoute(
        path: '/hackathon/placement-predictor',
        builder: (context, state) => const PlacementPredictorScreen(
          resumeScore: 85,
          lcSolved: 150,
          avgInterviewScore: 4.5,
          xpPoints: 5000,
          interviewsDone: 8,
          college: 'IIT Delhi',
          branch: 'CSE',
          graduationYear: 2024,
          skills: ['DSA', 'Web Dev', 'Flutter', 'Databases'],
          targetRole: 'SDE',
        ),
      ),
      GoRoute(
        path: '/hackathon/peer-interview',
        builder: (context, state) => const PeerInterviewScreen(
          userId: 'user123',
          userName: 'Student Name',
          userCollege: 'IIT Delhi',
        ),
      ),
      GoRoute(
        path: '/hackathon/college-analytics/:collegeCode',
        builder: (context, state) => CollegeDashboardScreen(
          collegeCode: state.pathParameters['collegeCode'] ?? 'DEFAULT',
          isProfessor: false,
        ),
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
