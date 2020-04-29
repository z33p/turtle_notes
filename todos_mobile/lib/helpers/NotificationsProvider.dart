import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:todos_mobile/models/Todo.dart';

class NotificationsProvider {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidInitializationSettings androidInitializationSettings;
  static IOSInitializationSettings iosInitializationSettings;
  static InitializationSettings initializationSettings;

  static Future onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  static Future<void> init() async {
    androidInitializationSettings = AndroidInitializationSettings("app_icon");
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  static Future<List<PendingNotificationRequest>> checkPendingNotificationRequests() async {
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  static Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "your channel id", "your channel name", "your channel description",
        importance: Importance.Max, priority: Priority.High, ticker: "ticker");
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, "Hello this is the title", "I'm z33p!", platformChannelSpecifics,
        payload: "item x");
  }

  static Future<void> showNotificationWithNoBody() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "your channel id", "your channel name", "your channel description",
        importance: Importance.Max, priority: Priority.High, ticker: "ticker");
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, "plain title", null, platformChannelSpecifics,
        payload: "item x");
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> showNotificationWithNoSound() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "silent channel id",
        "silent channel name",
        "silent channel description",
        playSound: false,
        styleInformation: DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, "<b>silent</b> title",
        "<b>silent</b> body", platformChannelSpecifics);
  }

  static Future<void> scheduleNotification(Todo todo) async {
    var scheduledNotificationDateTime = todo.reminderDateTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "your other channel id",
        "your other channel name",
        "your other channel description");
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await NotificationsProvider.flutterLocalNotificationsPlugin.schedule(
        todo.id,
        todo.title,
        "scheduled body",
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  static String toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  static Future<void> scheduleNotificationDaily(Todo todo) async {
    var time = Time(todo.reminderDateTime.hour, todo.reminderDateTime.minute,
        todo.reminderDateTime.second);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        todo.id,
        todo.title,
        'Daily notification shown at approximately ${toTwoDigitString(time.hour)}:${toTwoDigitString(time.minute)}:${toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);
  }

  static Future<void> scheduleNotificationWeekly(Todo todo) async {
    var time = Time(todo.reminderDateTime.hour, todo.reminderDateTime.minute,
        todo.reminderDateTime.second);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        todo.id,
        todo.title,
        todo.description,
        Day.values[todo.daysToRemind.indexWhere((day) => day)],
        time,
        platformChannelSpecifics);
  }
}
