// lib/data/services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class _Notifications {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'ageless_reminders',
    'Daily Reminders',
    description: 'Daily tracking and coaching reminders',
    importance: Importance.high,
  );
}

class NotificationService {
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _Notifications.plugin.initialize(initSettings);

    // Timezone init for scheduled notifications
    tzdata.initializeTimeZones();

    // Android 13+ permission is app-level; ensure requested elsewhere in UI.
    await _Notifications.plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_Notifications.channel);
  }

  /// Schedule daily reminder notifications
  Future<void> scheduleDailyReminders() async {
    final now = DateTime.now();
    final times = <Time>[
      const Time(8, 0),
      const Time(12, 0),
      const Time(20, 0)
    ];
    final messages = [
      ('Morning', 'Time to log your breakfast and plan your day'),
      ('Midday', "Don't forget your workout!"),
      ('Evening', 'Log your dinner and prepare for quality sleep'),
    ];

    for (int i = 0; i < times.length; i++) {
      final id = 100 + i;
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _Notifications.channel.id,
          _Notifications.channel.name,
          channelDescription: _Notifications.channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      );

      final scheduledDate = DateTime(
          now.year, now.month, now.day, times[i].hour, times[i].minute);

      // If time already passed today, schedule for tomorrow
      final firstFire = scheduledDate.isAfter(now)
          ? scheduledDate
          : scheduledDate.add(const Duration(days: 1));

      await _Notifications.plugin.zonedSchedule(
        id,
        messages[i].$1,
        messages[i].$2,
        tz.TZDateTime.from(firstFire, tz.local),
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Send achievement notification
  Future<void> sendAchievementNotification(String title, String body) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _Notifications.channel.id,
        _Notifications.channel.name,
        channelDescription: _Notifications.channel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _Notifications.plugin.show(
      200,
      title,
      body,
      details,
    );
  }

  /// Send streak reminder
  Future<void> sendStreakReminder(int streak) async {
    await sendAchievementNotification(
      'Keep your streak going! 🔥',
      'You are on a $streak day streak. Log today to keep it alive.',
    );
  }
}
