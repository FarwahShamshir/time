import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';

class NotificationService {
  // Define flutterLocalNotificationsPlugin as a static instance
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the notification system
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(); // iOS initialization

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onSelectNotificationResponse, // Updated callback
    );
  }

  // Handle when the user taps on a notification
  static Future<void> onSelectNotificationResponse(NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      print('Notification payload: ${notificationResponse.payload}');
      // You can navigate to another screen or handle custom logic here
    }
  }

  // Schedule a notification
  static Future<void> scheduleNotification(Task task, String alertMode) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_channel', // Channel ID
      'Task Notifications', // Channel Name
      importance: Importance.max,
      priority: Priority.high,
      sound: alertMode == 'Ring'
          ? RawResourceAndroidNotificationSound('notification_tune1') // Custom sound
          : null, // No sound for Vibrate or Silent modes
      enableVibration: alertMode == 'Vibrate',
      playSound: alertMode == 'Ring',
    );

    final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(task.time, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.time.millisecondsSinceEpoch ~/ 1000, // Unique notification ID
      task.title,
      task.description,
      scheduledDate, // Use TZDateTime for scheduling
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  // Cancel a notification
  static Future<void> cancelNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.time.millisecondsSinceEpoch ~/ 1000);
  }

  // Snooze a notification
  static Future<void> snoozeTaskNotification(Task task, int snoozeMinutes) async {
    final snoozeTime = task.time.add(Duration(minutes: snoozeMinutes));

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_channel', // Channel ID
      'Task Notifications', // Channel Name
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_tune1'),
    );

    final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    // Convert snoozeTime to TZDateTime
    final tz.TZDateTime snoozeDate = tz.TZDateTime.from(snoozeTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      snoozeDate.millisecondsSinceEpoch ~/ 1000, // Unique ID for snoozed notification
      task.title,
      task.description + ' (Snoozed)', // Mark as snoozed
      snoozeDate, // New snooze time as TZDateTime
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
