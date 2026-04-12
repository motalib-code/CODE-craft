import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/services/youtube_service.dart';

class TopicDetailScreen extends StatefulWidget {
  final String topicName;
  const TopicDetailScreen({super.key, required this.topicName});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _ytService = YoutubeService();
  List<YoutubeVideo> _videos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final videos = await _ytService.getTopicVideos(widget.topicName);
      if (mounted) setState(() { _videos = videos; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(widget.topicName),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Topic header
          Padding(
            padding: const EdgeInsets.all(20),
            child: FadeInDown(
              child: GlassCard(
                gradient: LinearGradient(
                  colors: [
                    AppColors.purple.withOpacity(0.15),
                    AppColors.blue.withOpacity(0.05),
                  ],
                ),
                borderColor: AppColors.borderPurple,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      text: widget.topicName,
                      style: AppTextStyles.h1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Master ${widget.topicName} concepts through videos and practice',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabCtrl,
            indicatorColor: AppColors.purple,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textHint,
            tabs: const [
              Tab(text: '🎥 Videos'),
              Tab(text: '📝 Notes'),
              Tab(text: '💻 Practice'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // Videos tab
                _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.purple))
                    : _videos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('📹',
                                    style: TextStyle(fontSize: 48)),
                                const SizedBox(height: 12),
                                Text('No videos found',
                                    style: AppTextStyles.h3),
                                const SizedBox(height: 4),
                                Text('Check back later',
                                    style: AppTextStyles.body),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: _videos.length,
                            itemBuilder: (_, i) {
                              final video = _videos[i];
                              return FadeInUp(
                                delay: Duration(milliseconds: i * 60),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: GlassCard(
                                    onTap: () => _openVideo(video),
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: AppColors.bgInput,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                                Icons.play_circle_fill,
                                                color: AppColors.purple,
                                                size: 28),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(video.title,
                                                  style: AppTextStyles.h3
                                                      .copyWith(
                                                          fontSize: 13),
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis),
                                              const SizedBox(height: 4),
                                              Text(video.channel,
                                                  style:
                                                      AppTextStyles.small),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                // Notes tab
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📝', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('Notes coming soon!',
                            style: AppTextStyles.h3),
                        const SizedBox(height: 4),
                        Text(
                            'AI-generated notes will appear here',
                            style: AppTextStyles.body),
                      ],
                    ),
                  ),
                ),

                // Practice tab
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GlassCard(
                        child: Column(
                          children: [
                            Text(
                                'Practice ${widget.topicName} problems',
                                style: AppTextStyles.h3),
                            const SizedBox(height: 12),
                            GradientButton(
                              label: 'Go to Practice',
                              icon: Icons.code,
                              onTap: () =>
                                  Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openVideo(YoutubeVideo video) async {
    final uri = Uri.parse(video.watchUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
