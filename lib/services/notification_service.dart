import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';
import '../models/news_article.dart';
import 'job_service.dart';
import 'news_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();

  static Timer? _jobPollingTimer;
  static Timer? _newsPollingTimer;
  static const String _seenJobsKey = 'seen_job_ids';
  static const String _seenNewsKey = 'seen_news_titles';

  static const AndroidNotificationChannel _jobChannel =
    AndroidNotificationChannel(
      'jobs_channel',
      'Job Alerts',
      description: 'New job opportunity notifications',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      enableLights: true,
      ledColor: Color(0xFF6B5CE7),
    );

  static const AndroidNotificationChannel _newsChannel =
    AndroidNotificationChannel(
      'news_channel',
      'Tech News',
      description: 'Latest tech and career news',
      importance: Importance.defaultImportance,
    );

  static const AndroidNotificationChannel _interviewChannel =
    AndroidNotificationChannel(
      'interview_channel',
      'Interview Reminders',
      description: 'Mock interview practice reminders',
      importance: Importance.high,
    );

  static const AndroidNotificationChannel _resumeChannel =
    AndroidNotificationChannel(
      'resume_channel',
      'Resume Updates',
      description: 'Resume analysis and tips',
      importance: Importance.defaultImportance,
    );

  static Future<void> initialize() async {
    if (kIsWeb) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    final androidPlugin = _plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_jobChannel);
    await androidPlugin?.createNotificationChannel(_newsChannel);
    await androidPlugin?.createNotificationChannel(_interviewChannel);
    await androidPlugin?.createNotificationChannel(_resumeChannel);
  }

  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      // Handle tap navigation based on payload if a navigator key is available.
    }
  }

  static Future<void> showJobAlert(Job job) async {
    await _plugin.show(
      job.id.hashCode,
      '🆕 New Job: ${job.title}',
      '${job.company} • ${job.location} • ${job.isRemote ? 'Remote' : 'On-site'}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _jobChannel.id,
          _jobChannel.name,
          channelDescription: _jobChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6B5CE7),
          styleInformation: BigTextStyleInformation(
            '${job.company}\n${job.location} • ${job.source}\n${job.tags.take(3).join(', ')}',
            htmlFormatBigText: false,
            contentTitle: '🆕 ${job.title}',
            summaryText: job.salary.isNotEmpty ? job.salary : 'View for details',
          ),
          largeIcon: job.logo.isNotEmpty
            ? const DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
            : null,
        ),
        iOS: const DarwinNotificationDetails(
          subtitle: '',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode({'type': 'job', 'url': job.url}),
    );
  }

  static Future<void> showNewsAlert(NewsArticle article) async {
    await _plugin.show(
      article.title.hashCode,
      '📰 ${article.source}: ${article.title}',
      article.description.isNotEmpty
        ? article.description
        : 'Tap to read more',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _newsChannel.id,
          _newsChannel.name,
          channelDescription: _newsChannel.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6B5CE7),
          styleInformation: BigTextStyleInformation(
            article.description,
            contentTitle: article.title,
            summaryText: article.timeAgo,
          ),
        ),
        iOS: const DarwinNotificationDetails(
          subtitle: '',
          presentAlert: true,
        ),
      ),
      payload: jsonEncode({'type': 'news', 'url': article.url}),
    );
  }

  static Future<void> showInterviewReminder({
    required String company,
    required String interviewType,
  }) async {
    await _plugin.show(
      DateTime.now().millisecond,
      '🎤 Time to Practice!',
      'Your daily $interviewType interview practice for $company is waiting',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _interviewChannel.id,
          _interviewChannel.name,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6B5CE7),
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true),
      ),
      payload: jsonEncode({'type': 'interview'}),
    );
  }

  static Future<void> showResumeScoreAlert(int score) async {
    final message = score >= 80
      ? 'Excellent! Your resume scores $score/100. You are interview ready! 🚀'
      : score >= 60
        ? 'Good resume! Score: $score/100. Check improvements to boost it further.'
        : 'Resume needs work. Score: $score/100. View AI suggestions to improve.';

    await _plugin.show(
      999,
      '📄 Resume Analysis Complete',
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _resumeChannel.id,
          _resumeChannel.name,
          channelDescription: _resumeChannel.description,
          importance: Importance.defaultImportance,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6B5CE7),
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true),
      ),
      payload: jsonEncode({'type': 'resume'}),
    );
  }

  static Future<void> showInterviewCompleteAlert({
    required String grade,
    required String company,
    required double score,
  }) async {
    await _plugin.show(
      888,
      '🎤 Interview Complete! Grade: $grade',
      '$company interview done. Score: ${score.toStringAsFixed(1)}/10. View your detailed report!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _interviewChannel.id,
          _interviewChannel.name,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6B5CE7),
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true),
      ),
      payload: jsonEncode({'type': 'interview_complete'}),
    );
  }

  static Future<void> showDailyTechTip(String tip) async {
    await _plugin.show(
      777,
      '💡 Daily DSA Tip',
      tip,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _newsChannel.id,
          _newsChannel.name,
          importance: Importance.low,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6B5CE7),
        ),
        iOS: const DarwinNotificationDetails(presentAlert: false),
      ),
    );
  }

  static void startJobPolling({
    required Function(Job) onNewJob,
    Duration interval = const Duration(minutes: 30),
  }) {
    _jobPollingTimer?.cancel();
    _jobPollingTimer = Timer.periodic(interval, (_) async {
      try {
        final jobs = await JobService.fetchAllJobs();
        final prefs = await SharedPreferences.getInstance();
        final seenIds = Set<String>.from(
          prefs.getStringList(_seenJobsKey) ?? []);

        final newJobs = jobs.where((j) =>
          j.id.isNotEmpty && !seenIds.contains(j.id) && j.isNew).toList();

        for (final job in newJobs.take(3)) {
          await showJobAlert(job);
          onNewJob(job);
          seenIds.add(job.id);
          await Future.delayed(const Duration(seconds: 2));
        }

        final updatedList = seenIds.toList();
        if (updatedList.length > 200) {
          updatedList.removeRange(0, updatedList.length - 200);
        }
        await prefs.setStringList(_seenJobsKey, updatedList);
      } catch (e) {
        // Silent fail - do not crash app
      }
    });
  }

  static void startNewsPolling({
    required Function(NewsArticle) onNewArticle,
    Duration interval = const Duration(hours: 2),
  }) {
    _newsPollingTimer?.cancel();
    _newsPollingTimer = Timer.periodic(interval, (_) async {
      try {
        final articles = await NewsService.fetchTopHeadlines();
        final prefs = await SharedPreferences.getInstance();
        final seenTitles = Set<String>.from(
          prefs.getStringList(_seenNewsKey) ?? []);

        final newArticles = articles.where((a) =>
          !seenTitles.contains(a.title)).toList();

        for (final article in newArticles.take(2)) {
          await showNewsAlert(article);
          onNewArticle(article);
          seenTitles.add(article.title);
          await Future.delayed(const Duration(seconds: 3));
        }

        final updatedList = seenTitles.toList();
        if (updatedList.length > 100) {
          updatedList.removeRange(0, updatedList.length - 100);
        }
        await prefs.setStringList(_seenNewsKey, updatedList);
      } catch (e) {
        // Silent fail
      }
    });
  }

  static Future<void> scheduleDailyInterviewReminder({
    int hour = 9,
    int minute = 0,
  }) async {
    await showInterviewReminder(
      company: 'Your Target Company',
      interviewType: 'Technical DSA',
    );
  }

  static void stopAllPolling() {
    _jobPollingTimer?.cancel();
    _newsPollingTimer?.cancel();
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
