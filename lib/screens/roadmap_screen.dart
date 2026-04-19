import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/roadmap.dart';
import '../providers/roadmap_provider.dart';
import '../widgets/roadmap_card.dart';

class CareerRoadmapScreen extends ConsumerStatefulWidget {
  const CareerRoadmapScreen({super.key});

  @override
  ConsumerState<CareerRoadmapScreen> createState() => _CareerRoadmapScreenState();
}

class _CareerRoadmapScreenState extends ConsumerState<CareerRoadmapScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _goal = 'Student';
  String _domain = 'Web Dev';
  double _level = 0;
  String _hours = '2hr';
  String _timeline = '6 months';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    Future.microtask(() => ref.read(roadmapProvider).loadTaskState());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roadmapProvider);
    final roadmap = state.roadmap;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadmap Advisor'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Completed'),
            Tab(text: 'In Progress'),
            Tab(text: 'To Do'),
            Tab(text: 'Weekly'),
            Tab(text: 'Milestones'),
          ],
        ),
      ),
      body: roadmap == null
          ? _Questionnaire(
              domain: _domain,
              level: _level,
              hours: _hours,
              timeline: _timeline,
              onDomainChanged: (v) => setState(() => _domain = v),
              onLevelChanged: (v) => setState(() => _level = v),
              onHoursChanged: (v) => setState(() => _hours = v),
              onTimelineChanged: (v) => setState(() => _timeline = v),
              onGenerate: () async {
                await ref.read(roadmapProvider).saveAnswers(
                      RoadmapAnswers(
                        goal: _goal,
                        domain: _domain,
                        level: _level == 0
                            ? 'Beginner'
                            : _level == 1
                                ? 'Intermediate'
                                : 'Advanced',
                        dailyHours: _hours,
                        timeline: _timeline,
                        currentSkills: const ['Flutter', 'Dart', 'Git', 'REST APIs'],
                        completedProjects: const ['Portfolio App', 'Todo App'],
                      ),
                    );
                await ref.read(roadmapProvider).generateRoadmap();
              },
              isLoading: state.isLoading,
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _overviewTab(state, roadmap),
                _completedTab(roadmap),
                _inProgressTab(roadmap),
                _todoTab(roadmap),
                _weeklyTab(state, roadmap),
                _milestonesTab(roadmap),
              ],
            ),
    );
  }

  Widget _overviewTab(RoadmapProvider provider, CareerRoadmap roadmap) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: const Color(0xFF21184A),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'You are ${roadmap.currentStatus}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: CircularPercentIndicator(
            radius: 62,
            lineWidth: 9,
            percent: roadmap.jobReadinessScore / 100,
            progressColor: const Color(0xFF6B5CE7),
            center: Text('${roadmap.jobReadinessScore}%'),
            footer: const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Job Readiness'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _countTile('Completed', roadmap.completedItems.length, Icons.check_circle),
            _countTile('In Progress', roadmap.inProgressItems.length, Icons.autorenew),
            _countTile('Todo', roadmap.todoItems.length, Icons.list_alt),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          color: const Color(0xFF3D2D87),
          child: ListTile(
            leading: const Icon(Icons.track_changes),
            title: const Text('Do This TODAY'),
            subtitle: Text(roadmap.nextImportantAction),
          ),
        ),
      ],
    );
  }

  Widget _countTile(String title, int count, IconData icon) {
    return Expanded(
      child: Card(
        color: const Color(0xFF21184A),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _completedTab(CareerRoadmap roadmap) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Great job! You have completed ${roadmap.completedItems.length} items.'),
        const SizedBox(height: 12),
        ...roadmap.completedItems.map(
          (item) => Card(
            color: const Color(0xFF21184A),
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(item.item),
              subtitle: Text('Evidence: ${item.evidence}\n${item.completedDate}'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inProgressTab(CareerRoadmap roadmap) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: roadmap.inProgressItems
          .map(
            (item) => Card(
              color: const Color(0xFF21184A),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.item, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: item.percentDone / 100),
                    const SizedBox(height: 8),
                    Text('Next Step: ${item.nextStep}'),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: () {}, child: const Text('Continue')),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _todoTab(CareerRoadmap roadmap) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: roadmap.todoItems
          .map(
            (item) => RoadmapCard(
              item: item,
              onOpenResource: () async {
                if (item.resources.isEmpty) return;
                final uri = Uri.parse(item.resources.first.url);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
            ),
          )
          .toList(),
    );
  }

  Widget _weeklyTab(RoadmapProvider provider, CareerRoadmap roadmap) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LinearProgressIndicator(value: provider.getCompletionPercentage()),
        const SizedBox(height: 12),
        ...roadmap.weeklyPlan.map(
          (week) => Card(
            color: const Color(0xFF21184A),
            child: ExpansionTile(
              title: Text('Week ${week.week}: ${week.focus}'),
              subtitle: Text('Goal: ${week.goal}'),
              children: week.tasks
                  .map(
                    (task) => CheckboxListTile(
                      value: provider.isTaskComplete(week.week, task),
                      onChanged: (_) => provider.toggleTaskComplete(week.week, task),
                      title: Text(task),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _milestonesTab(CareerRoadmap roadmap) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(roadmap.milestones.length, (index) {
        final m = roadmap.milestones[index];
        return TimelineTile(
          isFirst: index == 0,
          isLast: index == roadmap.milestones.length - 1,
          indicatorStyle: const IndicatorStyle(color: Color(0xFF6B5CE7), width: 16),
          beforeLineStyle: const LineStyle(color: Colors.white24),
          endChild: Card(
            color: const Color(0xFF21184A),
            child: ListTile(
              title: Text('Month ${m.month}: ${m.achievement}'),
              subtitle: Text(m.checkItems.join(' | ')),
            ),
          ),
        );
      }),
    );
  }
}

class _Questionnaire extends StatelessWidget {
  final String domain;
  final double level;
  final String hours;
  final String timeline;
  final ValueChanged<String> onDomainChanged;
  final ValueChanged<double> onLevelChanged;
  final ValueChanged<String> onHoursChanged;
  final ValueChanged<String> onTimelineChanged;
  final VoidCallback onGenerate;
  final bool isLoading;

  const _Questionnaire({
    required this.domain,
    required this.level,
    required this.hours,
    required this.timeline,
    required this.onDomainChanged,
    required this.onLevelChanged,
    required this.onHoursChanged,
    required this.onTimelineChanged,
    required this.onGenerate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Q1: Current role/goal'),
        const SizedBox(height: 4),
        const Card(child: ListTile(title: Text('Student'))),
        const SizedBox(height: 12),
        const Text('Q2: Target domain'),
        DropdownButtonFormField<String>(
          value: domain,
          items: const [
            'Web Dev',
            'Mobile Dev',
            'AI/ML',
            'DevOps',
            'Data Science',
            'Cybersecurity'
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => onDomainChanged(v ?? domain),
        ),
        const SizedBox(height: 12),
        const Text('Q3: Skill level'),
        Slider(
          value: level,
          max: 2,
          divisions: 2,
          label: level == 0 ? 'Beginner' : level == 1 ? 'Intermediate' : 'Advanced',
          onChanged: onLevelChanged,
        ),
        const SizedBox(height: 12),
        const Text('Q4: Hours/day'),
        DropdownButtonFormField<String>(
          value: hours,
          items: const ['1hr', '2hr', '4hr', '6hr+']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onHoursChanged(v ?? hours),
        ),
        const SizedBox(height: 12),
        const Text('Q5: Timeline'),
        DropdownButtonFormField<String>(
          value: timeline,
          items: const ['3 months', '6 months', '1 year']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onTimelineChanged(v ?? timeline),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : onGenerate,
          child: Text(isLoading ? 'Generating roadmap...' : 'Generate AI Roadmap'),
        ),
      ],
    );
  }
}
