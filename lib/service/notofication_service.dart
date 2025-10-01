// // lib/services/notification_service.dart
// import 'dart:developer';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   static const String _dailyReminderKey = 'daily_reminder_enabled';
//   static const String _weeklyReminderKey = 'weekly_reminder_enabled';
//   static const String _checkGoalsKey = 'check_goals_enabled';
//   static const String _healSessionKey = 'heal_session_enabled';

//   static Future<void> initialize() async {
//     tz.initializeTimeZones();

//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings(
//       requestAlertPermission: false, // Set to false to request later
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );

//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _notifications.initialize(settings);
//   }

//   // *** COMPREHENSIVE PERMISSION CHECK ***
//   static Future<bool> checkAllNotificationPermissions() async {
//     // 1. Check basic notification permission
//     final notificationStatus = await Permission.notification.status;
//     log("Notification permission status: $notificationStatus");

//     if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
//       log("Basic notification permission not granted");
//       return false;
//     }

//     // 2. Check exact alarms permission for Android
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         _notifications.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     if (androidImplementation != null) {
//       final bool? canScheduleExact =
//           await androidImplementation.canScheduleExactNotifications();
//       log("Can schedule exact notifications: $canScheduleExact");

//       if (canScheduleExact != true) {
//         log("Exact alarms permission not granted");
//         return false;
//       }
//     }

//     log("All notification permissions granted");
//     return true;
//   }

//   // *** REQUEST ALL PERMISSIONS ***
//   static Future<bool> requestAllNotificationPermissions() async {
//     try {
//       // 1. Request basic notification permission
//       final notificationStatus = await Permission.notification.status;

//       if (notificationStatus.isDenied) {
//         log("Requesting notification permission...");
//         final result = await Permission.notification.request();

//         if (!result.isGranted) {
//           log("Notification permission denied by user");
//           if (result.isPermanentlyDenied) {
//             log("Notification permission permanently denied - opening settings");
//             await openAppSettings();
//           }
//           return false;
//         }
//       } else if (notificationStatus.isPermanentlyDenied) {
//         log("Notification permission permanently denied - opening settings");
//         await openAppSettings();
//         return false;
//       }

//       // 2. Request exact alarms permission for Android
//       final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//           _notifications.resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>();

//       if (androidImplementation != null) {
//         final bool? canScheduleExact =
//             await androidImplementation.canScheduleExactNotifications();

//         if (canScheduleExact != true) {
//           log("Requesting exact alarms permission...");
//           final result =
//               await androidImplementation.requestExactAlarmsPermission();

//           if (result != true) {
//             log("Exact alarms permission denied by user");
//             return false;
//           }
//         }
//       }

//       log("All permissions granted successfully");
//       return true;
//     } catch (e) {
//       log("Error requesting permissions: $e");
//       return false;
//     }
//   }

//   // *** SCHEDULE WITH PERMISSION CHECK ***
//   static Future<bool> scheduleDailyReminder(bool enable) async {
//     await _savePreference(_dailyReminderKey, enable);

//     if (enable) {
//       // Check permissions first
//       bool hasPermissions = await checkAllNotificationPermissions();

//       if (!hasPermissions) {
//         log("Requesting permissions for daily reminder...");
//         hasPermissions = await requestAllNotificationPermissions();

//         if (!hasPermissions) {
//           log("Cannot schedule daily reminder - permissions not granted");
//           return false;
//         }
//       }

//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//         'daily_reminder_channel',
//         'Daily Reminder',
//         channelDescription: 'Channel for daily reminder notifications',
//         importance: Importance.high,
//         priority: Priority.high,
//       );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: DarwinNotificationDetails(),
//       );

//       final now = tz.TZDateTime.now(tz.local);
//       var scheduledDate = tz.TZDateTime(
//         tz.local,
//         now.year,
//         now.month,
//         now.day,
//         3, // 8 AM
//         19,
//       );

//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }

//       try {
//         await _notifications.zonedSchedule(
//           1,
//           'Daily Reminder',
//           'Time for your daily mindfulness practice! 🧘‍♀️',
//           scheduledDate,
//           notificationDetails,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           // uiLocalNotificationDateInterpretation:
//           // UILocalNotificationDateInterpretation.absoluteTime,
//           matchDateTimeComponents: DateTimeComponents.time,
//         );
//         log("Daily reminder scheduled successfully");
//         return true;
//       } catch (e) {
//         log("Error scheduling daily reminder: $e");
//         return false;
//       }
//     } else {
//       await _notifications.cancel(1);
//       return true;
//     }
//   }

//   // *** SCHEDULE WEEKLY WITH PERMISSION CHECK ***
//   static Future<bool> scheduleWeeklyReminder(
//       bool enable, String selectedDay) async {
//     await _savePreference(_weeklyReminderKey, enable);

//     if (enable) {
//       // Check permissions first
//       bool hasPermissions = await checkAllNotificationPermissions();

//       if (!hasPermissions) {
//         log("Requesting permissions for weekly reminder...");
//         hasPermissions = await requestAllNotificationPermissions();

//         if (!hasPermissions) {
//           log("Cannot schedule weekly reminder - permissions not granted");
//           return false;
//         }
//       }

//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//         'weekly_reminder_channel',
//         'Weekly Reminder',
//         channelDescription: 'Channel for weekly reminder notifications',
//         importance: Importance.high,
//         priority: Priority.high,
//       );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: DarwinNotificationDetails(),
//       );

//       final weekDay = _getWeekdayNumber(selectedDay);
//       final now = tz.TZDateTime.now(tz.local);

//       var scheduledDate = tz.TZDateTime(
//         tz.local,
//         now.year,
//         now.month,
//         now.day,
//         9, // 9 AM
//         0,
//       );

//       while (scheduledDate.weekday != weekDay || scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }

//       try {
//         await _notifications.zonedSchedule(
//           2,
//           'Weekly Reminder',
//           'Your weekly reflection time is here! 📝',
//           scheduledDate,
//           notificationDetails,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           // uiLocalNotificationDateInterpretation:
//           // UILocalNotificationDateInterpretation.absoluteTime,
//           matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//         );
//         log("Weekly reminder scheduled successfully");
//         return true;
//       } catch (e) {
//         log("Error scheduling weekly reminder: $e");
//         return false;
//       }
//     } else {
//       await _notifications.cancel(2);
//       return true;
//     }
//   }

//   // *** SCHEDULE CHECK GOALS WITH PERMISSION CHECK ***
//   static Future<bool> scheduleCheckGoals(bool enable) async {
//     await _savePreference(_checkGoalsKey, enable);

//     if (enable) {
//       // Check permissions first
//       bool hasPermissions = await checkAllNotificationPermissions();

//       if (!hasPermissions) {
//         log("Requesting permissions for check goals...");
//         hasPermissions = await requestAllNotificationPermissions();

//         if (!hasPermissions) {
//           log("Cannot schedule check goals - permissions not granted");
//           return false;
//         }
//       }

//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//         'check_goals_channel',
//         'Check Goals',
//         channelDescription: 'Channel for goals checking notifications',
//         importance: Importance.high,
//         priority: Priority.high,
//       );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: DarwinNotificationDetails(),
//       );

//       final now = tz.TZDateTime.now(tz.local);
//       var scheduledDate = tz.TZDateTime(
//         tz.local,
//         now.year,
//         now.month,
//         now.day,
//         20, // 8 PM
//         0,
//       );

//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }

//       try {
//         await _notifications.zonedSchedule(
//           3,
//           'Check Your Goals',
//           'How are you progressing with your goals today? 🎯',
//           scheduledDate,
//           notificationDetails,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           // uiLocalNotificationDateInterpretation:
//           // UILocalNotificationDateInterpretation.absoluteTime,
//           matchDateTimeComponents: DateTimeComponents.time,
//         );
//         log("Check goals scheduled successfully");
//         return true;
//       } catch (e) {
//         log("Error scheduling check goals: $e");
//         return false;
//       }
//     } else {
//       await _notifications.cancel(3);
//       return true;
//     }
//   }

//   // *** SCHEDULE HEAL SESSION WITH PERMISSION CHECK ***
//   static Future<bool> scheduleHealSession(bool enable) async {
//     await _savePreference(_healSessionKey, enable);

//     if (enable) {
//       // Check permissions first
//       bool hasPermissions = await checkAllNotificationPermissions();

//       if (!hasPermissions) {
//         log("Requesting permissions for heal session...");
//         hasPermissions = await requestAllNotificationPermissions();

//         if (!hasPermissions) {
//           log("Cannot schedule heal session - permissions not granted");
//           return false;
//         }
//       }

//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//         'heal_session_channel',
//         'Heal Session',
//         channelDescription: 'Channel for healing session notifications',
//         importance: Importance.high,
//         priority: Priority.high,
//       );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: DarwinNotificationDetails(),
//       );

//       final now = tz.TZDateTime.now(tz.local);
//       var scheduledDate = tz.TZDateTime(
//         tz.local,
//         now.year,
//         now.month,
//         now.day,
//         18, // 6 PM
//         0,
//       );

//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }

//       try {
//         await _notifications.zonedSchedule(
//           4,
//           'Healing Session Time',
//           'Ready for your healing session? Find your peace 🌸',
//           scheduledDate,
//           notificationDetails,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           // uiLocalNotificationDateInterpretation:
//           // UILocalNotificationDateInterpretation.absoluteTime,
//           matchDateTimeComponents: DateTimeComponents.time,
//         );
//         log("Heal session scheduled successfully");
//         return true;
//       } catch (e) {
//         log("Error scheduling heal session: $e");
//         return false;
//       }
//     } else {
//       await _notifications.cancel(4);
//       return true;
//     }
//   }

//   // Rest of the methods remain same...
//   static Future<void> cancelAllNotificationsOnLogout() async {
//     await _notifications.cancelAll();

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_dailyReminderKey);
//     await prefs.remove(_weeklyReminderKey);
//     await prefs.remove(_checkGoalsKey);
//     await prefs.remove(_healSessionKey);

//     log("All notifications cancelled and preferences cleared on logout");
//   }

//   static int _getWeekdayNumber(String day) {
//     const days = {
//       'Monday': 1,
//       'Tuesday': 2,
//       'Wednesday': 3,
//       'Thursday': 4,
//       'Friday': 5,
//       'Saturday': 6,
//       'Sunday': 7,
//     };
//     return days[day] ?? 1;
//   }

//   static Future<void> _savePreference(String key, bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(key, value);
//   }

//   static Future<bool> getPreference(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(key) ?? false;
//   }

//   static Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }

//   static Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }
// }
