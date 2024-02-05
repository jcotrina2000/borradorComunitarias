import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../screens/assignment_provider.dart';
import '../screens/courses_provider.dart';

class NotificationCLient {
  NotificationCLient();
  List<int> idList = [];

  List<dynamic> notificationList = [];

  final _notificationClient = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> onNotificationClick = BehaviorSubject();

  BuildContext get context => throw Exception("Context not provided");

  Future<void> intialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('launcher_icon');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationClient.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      'description',
      playSound: true,
      priority: Priority.max,
      importance: Importance.max,
      ticker: 'ticker',
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
  ) async {
    final details = await _notificationDetails();
    await _notificationClient.show(id, title, body, details);
  }

  Future<void> showNotificationWithPayload(
      int id, String title, String body, String payload) async {
    _showGreenPoints(payload);
    final details = await _notificationDetails();
    await _notificationClient.show(id, title, body, details, payload: payload);
  }

  Future<dynamic> onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {}

  Future<dynamic> onSelectNotification(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

  void _showGreenPoints(String payload) {
    String courseId = payload.split(',')[0];
    String assignmentId = payload.split(',')[1];
    for (var curso in CoursesProvider.availableCourses) {
      if (curso.id == int.parse(courseId)) {
        curso.showPoint = true;
      }
    }
    for (var assignment in AssignmentProvider.toDoList) {
      if (assignment.id == int.parse(assignmentId)) {
        assignment.showPoint = true;
      }
    }
  }
}
