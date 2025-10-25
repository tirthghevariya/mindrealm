import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_latest/flutter_native_timezone_latest.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await notifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) async =>
            onNotifications.add(payload.payload));

    if (initScheduled) {
      tz.initializeTimeZones();
      var locationName = await FlutterNativeTimezoneLatest.getLocalTimezone();

      // Replace "Asia/Calcutta" with "Asia/Kolkata" if necessary
      if (locationName == "Asia/Calcutta") {
        locationName = "Asia/Kolkata";
      }

      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future<List<PendingNotificationRequest>>
      returnPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await notifications.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  static Future<NotificationDetails> weeklyNotificationDetails() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '02',
      'weekly_notification_channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    return const NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
  }

  static Future<NotificationDetails> dailyNotificationDetails() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '01',
      'daily_notification_channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    return const NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
  }

  static Future<void> cancelAllNotifications() async {
    await notifications.cancelAll();
  }

  static Future<int> countPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await notifications.pendingNotificationRequests();
    return pendingNotifications.length;
  }

  static Future<void> showWeeklyScheduleNotification({
    String? title,
    String? body,
    String? payload,
    required List<int> time,
    required List<int> weekDays,
  }) async {
    try {
      // Check permission before scheduling
      // await notifications.cancel(2);
      final androidImplementation =
          notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (Platform.isAndroid) {
        final hasExactAlarmPermission =
            await androidImplementation?.canScheduleExactNotifications() ??
                false;

        if (!hasExactAlarmPermission) {
          throw PlatformException(
            code: 'exact_alarms_not_permitted',
            message: 'Exact alarms permission not granted',
          );
        }
      }
      int day = weekDays.first;

      await notifications.zonedSchedule(
        2,
        title ?? 'Weekly Reminder',
        body ??
            "Time to energize your day with some exercise! 🌟 Let's get moving and feel great!",
        _scheduleWeekly([time[0], time[1], time[2]], days: [day]),
        await weeklyNotificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } catch (e) {
      debugPrint('Error when setting reminder: ${e.toString()}');
      rethrow; // Rethrow to handle in UI
    }
  }

  static tz.TZDateTime _scheduleWeekly(time, {required List<int> days}) {
    tz.TZDateTime scheduleDate = _scheduleDaily(time);
    while (!days.contains(scheduleDate.weekday)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  static Future<void> showDailyScheduleNotification({
    String? title,
    String? body,
    String? payload,
    required List<int> time, // [hour, minute, second]
  }) async {
    try {
      await notifications.cancel(1);
      await notifications.zonedSchedule(
        1,
        title ?? 'How are you feeling today?',
        body ?? 'Take a moment for your daily reflection.',
        _scheduleDaily(time),
        await dailyNotificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // repeat daily
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
      );
      log("0-=0=-0-=0-=0-=0-=0=-0 ${_scheduleDaily(time)}");
    } catch (e) {
      debugPrint('Error when setting daily reminder: ${e.toString()}');
    }
  }

  static tz.TZDateTime _scheduleDaily(time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time[0], time[1], time[2]);
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

// For Heal Notification (Monday)
  static Future<void> showHealNotification({
    int hour = 8,
    int minute = 0,
  }) async {
    await notifications.cancel(3);
    await notifications.zonedSchedule(
      3, // Unique ID for Heal
      'Heal Reminder',
      'It\'s Monday! Take a moment to engage with MindRealm and check in on your wellbeing.',
      _scheduleWeekly([hour, minute, 0], days: [DateTime.monday]),
      await weeklyNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

// For Goals Notification (Thursday 8AM)
  static Future<void> showGoalsNotification({
    int hour = 8,
    int minute = 0,
  }) async {
    await notifications.cancel(4);
    await notifications.zonedSchedule(
      4, // Unique ID for Goals
      'Goals Reminder',
      'Remember to check and update your goals for this week!',
      _scheduleWeekly([hour, minute, 0], days: [DateTime.thursday]),
      await weeklyNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<bool> checkAndRequestPermissions() async {
    // 1. Request basic notification permission
    final notificationStatus = await Permission.notification.status;
    if (notificationStatus.isDenied) {
      log("Requesting notification permission...");
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        log("Notification permission denied by user");
        if (result.isPermanentlyDenied) {
          log("Notification permission permanently denied - opening settings");
          await openAppSettings();
        }
        return false;
      }
    } else if (notificationStatus.isPermanentlyDenied) {
      log("Notification permission permanently denied - opening settings");
      await openAppSettings();
      return false;
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation == null) return false;

      // Check notification permission
      final bool? hasNotificationPermission =
          await androidImplementation.areNotificationsEnabled();

      // Check exact alarm permission
      final bool? hasExactAlarmPermission =
          await androidImplementation.canScheduleExactNotifications();

      // If either permission is not granted
      if (hasNotificationPermission != true ||
          hasExactAlarmPermission != true) {
        // Request notification permission if needed
        if (hasNotificationPermission != true) {
          await androidImplementation.requestExactAlarmsPermission();
        }

        // Request exact alarm permission if needed
        if (hasExactAlarmPermission != true) {
          await androidImplementation.requestExactAlarmsPermission();
        }

        // Check permissions again after requesting
        final bool? newNotificationPermission =
            await androidImplementation.areNotificationsEnabled();
        final bool? newExactAlarmPermission =
            await androidImplementation.canScheduleExactNotifications();

        // Return true only if both permissions are granted
        return newNotificationPermission == true &&
            newExactAlarmPermission == true;
      }

      return true;
    } else if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? iOSImplementation =
          notifications.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iOSImplementation == null) return false;

      final bool? result = await iOSImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return result ?? false;
    }

    return false;
  }
}
