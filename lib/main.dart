import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tea/features/shop/screens/home/services/notification_services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'app.dart';
import 'features/shop/controllers/ActionPlan/ActionPlanController.dart';
import 'features/shop/controllers/Events/EventsController.dart';
import 'features/shop/controllers/Goal/GoalController.dart';
import 'features/shop/controllers/Review/ReviewController.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// 2️⃣ Initialize notifications
Future<void> initializeNotifications() async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();

  debugPrint('✅ Notifications initialized');
}

/// ✅ Schedule a notification
Future<void> scheduleAlarm(
    int id, DateTime scheduledTime, String message) async {
  final androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Reminders',
    channelDescription: 'Channel for action plan reminders',
    importance: Importance.max,
    priority: Priority.high,
  );

  final notificationDetails = NotificationDetails(android: androidDetails);

  final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    '⏰ Reminder',
    message,
    tzTime,
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: null,
  );

  debugPrint('✅ Notification scheduled for $tzTime');
}


/// 3️⃣ Schedule a notification
Future<void> scheduleNotification(
    int id, DateTime scheduledTime, String message) async {
  const androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Reminders',
    channelDescription: 'Channel for action plan reminders',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    '⏰ Reminder',
    message,
    tzTime,
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  debugPrint('✅ Notification scheduled for $tzTime');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await configureLocalTimeZone();
  await GetStorage.init();
  await NotificationService.initializeNotification();

  Get.put(GoalController());
  Get.put(ActionPlanController());
  Get.put(EventController());
  Get.put(ReviewController());

  await initializeNotifications();

  runApp(const MyApp());
}

