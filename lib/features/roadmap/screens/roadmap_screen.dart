import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:codecraft/core/services/youtube_service.dart';
import 'package:codecraft/core/widgets/gradient_button.dart';
import 'package:codecraft/core/widgets/glass_card.dart';
import 'package:codecraft/core/constants/app_colors.dart';
import 'package:codecraft/core/constants/app_text_styles.dart';

final youtubeServiceProvider = Provider<YoutubeService>((ref) => YoutubeService());

// Popular Roadmap.sh direct links - moved outside class to avoid const issues
const List<Map<String, String>> roadmapsList = [
  // Role-based
  {'title': 'Frontend', 'url': 'https://roadmap.sh/frontend', 'topic': 'Frontend'},
  {'title': 'Backend', 'url': 'https://roadmap.sh/backend', 'topic': 'Backend'},
  {'title': 'Full Stack', 'url': 'https://roadmap.sh/full-stack', 'topic': 'Full Stack'},
  {'title': 'DevOps', 'url': 'https://roadmap.sh/devops', 'topic': 'DevOps'},
  {'title': 'DevSecOps', 'url': 'https://roadmap.sh/devsecops', 'topic': 'DevSecOps'},
  {'title': 'Data Analyst', 'url': 'https://roadmap.sh/data-analyst', 'topic': 'Data Analyst'},
  {'title': 'AI Engineer', 'url': 'https://roadmap.sh/ai-engineer', 'topic': 'AI Engineer'},
  {'title': 'AI and Data Scientist', 'url': 'https://roadmap.sh/ai-data-scientist', 'topic': 'AI and Data Scientist'},
  {'title': 'Data Engineer', 'url': 'https://roadmap.sh/data-engineer', 'topic': 'Data Engineer'},
  {'title': 'Android', 'url': 'https://roadmap.sh/android', 'topic': 'Android'},
  {'title': 'Machine Learning', 'url': 'https://roadmap.sh/ai-data-scientist', 'topic': 'Machine Learning'},
  {'title': 'PostgreSQL', 'url': 'https://roadmap.sh/postgresql-dba', 'topic': 'PostgreSQL'},
  {'title': 'iOS', 'url': 'https://roadmap.sh/ios', 'topic': 'iOS'},
  {'title': 'Blockchain', 'url': 'https://roadmap.sh/blockchain', 'topic': 'Blockchain'},
  {'title': 'QA', 'url': 'https://roadmap.sh/qa', 'topic': 'QA'},
  {'title': 'Software Architect', 'url': 'https://roadmap.sh/software-architect', 'topic': 'Software Architect'},
  {'title': 'Cyber Security', 'url': 'https://roadmap.sh/cyber-security', 'topic': 'Cyber Security'},
  {'title': 'UX Design', 'url': 'https://roadmap.sh/ux-design', 'topic': 'UX Design'},
  {'title': 'Technical Writer', 'url': 'https://roadmap.sh/technical-writer', 'topic': 'Technical Writer'},
  {'title': 'Game Developer', 'url': 'https://roadmap.sh/game-developer', 'topic': 'Game Developer'},
  {'title': 'Server Side Game Developer', 'url': 'https://roadmap.sh/server-side-game-developer', 'topic': 'Server Side Game Developer'},
  {'title': 'MLOps', 'url': 'https://roadmap.sh/mlops', 'topic': 'MLOps'},
  {'title': 'Product Manager', 'url': 'https://roadmap.sh/product-manager', 'topic': 'Product Manager'},
  {'title': 'Engineering Manager', 'url': 'https://roadmap.sh/engineering-manager', 'topic': 'Engineering Manager'},
  {'title': 'Developer Relations', 'url': 'https://roadmap.sh/developer-relations', 'topic': 'Developer Relations'},
  {'title': 'BI Analyst', 'url': 'https://roadmap.sh/bi-analyst', 'topic': 'BI Analyst'},
  {'title': 'SQL', 'url': 'https://roadmap.sh/sql', 'topic': 'SQL'},
  {'title': 'Computer Science', 'url': 'https://roadmap.sh/computer-science', 'topic': 'Computer Science'},
  {'title': 'React', 'url': 'https://roadmap.sh/react', 'topic': 'React'},
  {'title': 'Vue', 'url': 'https://roadmap.sh/vue', 'topic': 'Vue'},
  {'title': 'Angular', 'url': 'https://roadmap.sh/angular', 'topic': 'Angular'},
  {'title': 'JavaScript', 'url': 'https://roadmap.sh/javascript', 'topic': 'JavaScript'},
  {'title': 'TypeScript', 'url': 'https://roadmap.sh/typescript', 'topic': 'TypeScript'},
  {'title': 'Node.js', 'url': 'https://roadmap.sh/nodejs', 'topic': 'Node.js'},
  {'title': 'Python', 'url': 'https://roadmap.sh/python', 'topic': 'Python'},
  {'title': 'System Design', 'url': 'https://roadmap.sh/system-design', 'topic': 'System Design'},
  {'title': 'Java', 'url': 'https://roadmap.sh/java', 'topic': 'Java'},
  {'title': 'ASP.NET Core', 'url': 'https://roadmap.sh/aspnet-core', 'topic': 'ASP.NET Core'},
  {'title': 'API Design', 'url': 'https://roadmap.sh/api-design', 'topic': 'API Design'},
  {'title': 'Spring Boot', 'url': 'https://roadmap.sh/spring-boot', 'topic': 'Spring Boot'},
  {'title': 'Flutter', 'url': 'https://roadmap.sh/flutter', 'topic': 'Flutter'},
  {'title': 'C++', 'url': 'https://roadmap.sh/cpp', 'topic': 'C++'},
  {'title': 'Rust', 'url': 'https://roadmap.sh/rust', 'topic': 'Rust'},
  {'title': 'Go Roadmap', 'url': 'https://roadmap.sh/golang', 'topic': 'Go'},
  {'title': 'Design and Architecture', 'url': 'https://roadmap.sh/design-architecture', 'topic': 'Design and Architecture'},
  {'title': 'GraphQL', 'url': 'https://roadmap.sh/graphql', 'topic': 'GraphQL'},
  {'title': 'React Native', 'url': 'https://roadmap.sh/react-native', 'topic': 'React Native'},
  {'title': 'Design System', 'url': 'https://roadmap.sh/design-system', 'topic': 'Design System'},
  {'title': 'Prompt Engineering', 'url': 'https://roadmap.sh/prompt-engineering', 'topic': 'Prompt Engineering'},
  {'title': 'MongoDB', 'url': 'https://roadmap.sh/mongodb', 'topic': 'MongoDB'},
  {'title': 'Linux', 'url': 'https://roadmap.sh/linux', 'topic': 'Linux'},
  {'title': 'Kubernetes', 'url': 'https://roadmap.sh/kubernetes', 'topic': 'Kubernetes'},
  {'title': 'Docker', 'url': 'https://roadmap.sh/docker', 'topic': 'Docker'},
  {'title': 'AWS', 'url': 'https://roadmap.sh/aws', 'topic': 'AWS'},
  {'title': 'Terraform', 'url': 'https://roadmap.sh/terraform', 'topic': 'Terraform'},
  {'title': 'Data Structures & Algorithms', 'url': 'https://roadmap.sh/datastructures-and-algorithms', 'topic': 'Data Structures & Algorithms'},
  {'title': 'Redis', 'url': 'https://roadmap.sh/redis', 'topic': 'Redis'},
  {'title': 'Git and GitHub', 'url': 'https://roadmap.sh/git-github', 'topic': 'Git and GitHub'},
  {'title': 'PHP', 'url': 'https://roadmap.sh/php', 'topic': 'PHP'},
  {'title': 'Cloudflare', 'url': 'https://roadmap.sh/cloudflare', 'topic': 'Cloudflare'},
  {'title': 'AI Red Teaming', 'url': 'https://roadmap.sh/ai-red-teaming', 'topic': 'AI Red Teaming'},
  {'title': 'AI Agents', 'url': 'https://roadmap.sh/ai-agents', 'topic': 'AI Agents'},
  {'title': 'Next.js', 'url': 'https://roadmap.sh/nextjs', 'topic': 'Next.js'},
  {'title': 'Code Review', 'url': 'https://roadmap.sh/code-review', 'topic': 'Code Review'},
  {'title': 'Kotlin', 'url': 'https://roadmap.sh/kotlin', 'topic': 'Kotlin'},
  {'title': 'HTML', 'url': 'https://roadmap.sh/html', 'topic': 'HTML'},
  {'title': 'CSS', 'url': 'https://roadmap.sh/css', 'topic': 'CSS'},
  {'title': 'Swift & Swift UI', 'url': 'https://roadmap.sh/swift', 'topic': 'Swift'},
  {'title': 'Shell / Bash', 'url': 'https://roadmap.sh/bash', 'topic': 'Shell / Bash'},
  {'title': 'Laravel', 'url': 'https://roadmap.sh/laravel', 'topic': 'Laravel'},
  {'title': 'Elasticsearch', 'url': 'https://roadmap.sh/elasticsearch', 'topic': 'Elasticsearch'},
  {'title': 'WordPress', 'url': 'https://roadmap.sh/wordpress', 'topic': 'WordPress'},
  {'title': 'Django', 'url': 'https://roadmap.sh/django', 'topic': 'Django'},
  {'title': 'Ruby', 'url': 'https://roadmap.sh/ruby', 'topic': 'Ruby'},
  {'title': 'Ruby on Rails', 'url': 'https://roadmap.sh/ruby-on-rails', 'topic': 'Ruby on Rails'},
  {'title': 'Claude Code', 'url': 'https://roadmap.sh/claude-code', 'topic': 'Claude Code'},
  {'title': 'Vibe Coding', 'url': 'https://roadmap.sh/vibe-coding', 'topic': 'Vibe Coding'},
  {'title': 'Scala', 'url': 'https://roadmap.sh/scala', 'topic': 'Scala'},
  {'title': 'OpenClaw', 'url': 'https://roadmap.sh/openclaw', 'topic': 'OpenClaw'},
  {'title': 'Project Ideas', 'url': 'https://roadmap.sh/project-ideas', 'topic': 'Project Ideas'},
  {'title': 'Best Practices', 'url': 'https://roadmap.sh/best-practices', 'topic': 'Best Practices'},
  {'title': 'API Security', 'url': 'https://roadmap.sh/api-security', 'topic': 'API Security'},
  {'title': 'Backend Performance', 'url': 'https://roadmap.sh/backend-performance', 'topic': 'Backend Performance'},
  {'title': 'Frontend Performance', 'url': 'https://roadmap.sh/frontend-performance', 'topic': 'Frontend Performance'},
];

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  Future<void> _openRoadmap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // best for both Android & Web
    }
  }

  Future<void> _openYouTubeForTopic(String topic, WidgetRef ref) async {
    final youtube = ref.read(youtubeServiceProvider);
    final videos = await youtube.getTopicVideos(topic);
    if (videos.isNotEmpty) {
      final videoUrl = videos.first.watchUrl;
      final uri = Uri.parse(videoUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // fallback search
      final searchVideos = await youtube.searchVideos('$topic tutorial for beginners');
      if (searchVideos.isNotEmpty) {
        await launchUrl(Uri.parse(searchVideos.first.watchUrl), mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roadmap')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // BIG BUTTON — Full roadmap.sh
            GlassCard(
              onTap: () => _openRoadmap('https://roadmap.sh/'),
              child: Column(
                children: [
                  const Icon(Icons.map_outlined, size: 48, color: AppColors.purple),
                  const SizedBox(height: 12),
                  Text(
                    'Open Full Interactive Roadmap.sh',
                    style: AppTextStyles.h2.copyWith(color: AppColors.purple),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sab kuch explore karo — progress track, PDF download, everything!',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    label: '🚀 Open Roadmap.sh',
                    onTap: () => _openRoadmap('https://roadmap.sh/'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Topic Cards
            Text('Popular Roadmaps', style: AppTextStyles.h1),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: roadmapsList.length,
                itemBuilder: (context, index) {
                  final item = roadmapsList[index];
                  return GlassCard(
                    onTap: () {
                      // 1. Open roadmap.sh specific page
                      _openRoadmap(item['url']!);
                      // 2. Automatically open best YouTube video for this topic
                      _openYouTubeForTopic(item['topic']!, ref);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item['title']!, style: AppTextStyles.h3),
                        const SizedBox(height: 8),
                        const Text('Tap → Roadmap + Video', 
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
