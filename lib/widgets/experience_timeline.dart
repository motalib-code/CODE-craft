import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../core/constants/app_colors.dart';
import '../models/linkedin_profile.dart';

class ExperienceTimeline extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceTimeline({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    if (experiences.isEmpty) {
      return const Text('No experience added yet.');
    }

    return Column(
      children: List.generate(experiences.length, (index) {
        final item = experiences[index];
        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: index == 0,
          isLast: index == experiences.length - 1,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: item.isCurrent ? AppColors.purple : Colors.grey,
            iconStyle: IconStyle(
              iconData: Icons.work_outline,
              color: Colors.white,
            ),
          ),
          beforeLineStyle: const LineStyle(color: Colors.white24, thickness: 1.5),
          endChild: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 16),
            child: Card(
              color: const Color(0xFF21184A),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.business, color: Colors.white70),
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.company}\n${item.startDate} - ${item.endDate.isEmpty ? 'Present' : item.endDate}',
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
