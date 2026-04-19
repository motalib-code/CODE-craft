import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/algo_topic.dart';

class AlgoTopicCard extends StatefulWidget {
  final AlgoTopic topic;
  final Function(String) onSubtopicTap;
  final VoidCallback onGFGTap;
  final VoidCallback onVideosTap;

  const AlgoTopicCard({
    super.key,
    required this.topic,
    required this.onSubtopicTap,
    required this.onGFGTap,
    required this.onVideosTap,
  });

  @override
  State<AlgoTopicCard> createState() => _AlgoTopicCardState();
}

class _AlgoTopicCardState extends State<AlgoTopicCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1550),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() => _expanded = expanded);
        },
        leading: Text(
          widget.topic.icon,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          widget.topic.name,
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        trailing: Wrap(
          children: [
            Text(
              '${widget.topic.subtopics.length} topics',
              style: AppTextStyles.small.copyWith(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.purple,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtopics wrap
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.topic.subtopics
                      .map((subtopic) => ActionChip(
                            label: Text(
                              subtopic,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: const Color(0xFF2D2070),
                            onPressed: () =>
                                widget.onSubtopicTap(subtopic),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.article,
                            color: AppColors.purple),
                        label: const Text('Read on GFG',
                            style: TextStyle(color: AppColors.purple)),
                        onPressed: widget.onGFGTap,
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.play_circle, color: Colors.red),
                        label: const Text('Watch Videos',
                            style: TextStyle(color: Colors.red)),
                        onPressed: widget.onVideosTap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
