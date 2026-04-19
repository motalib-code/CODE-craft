import 'package:flutter/material.dart';

import '../models/roadmap.dart';

class RoadmapCard extends StatelessWidget {
  final RoadmapItem item;
  final VoidCallback? onOpenResource;

  const RoadmapCard({
    super.key,
    required this.item,
    this.onOpenResource,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF21184A),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: item.priority == 1
                      ? Colors.red
                      : item.priority == 2
                          ? Colors.orange
                          : Colors.green,
                  child: Text(
                    'P${item.priority}',
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.description),
            const SizedBox(height: 8),
            Text('Est. ${item.estimatedDays} days | ${item.milestone}'),
            if (item.resources.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.resources
                    .map(
                      (r) => ActionChip(
                        label: Text(r.name),
                        onPressed: onOpenResource,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
