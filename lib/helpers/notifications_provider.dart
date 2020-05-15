import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoForm/TodoForm.dart';

ValueNotifier<List<PendingNotificationRequest>> notificationsController =
    ValueNotifier(List());

void addNotificationController(Todo todo) {
  notificationsController.value.add(
    PendingNotificationRequest(
      todo.id,
      todo.title,
      "",
      todo.id.toString(),
    ),
  );
}

Future<List<PendingNotificationRequest>>
    checkPendingNotificationRequests() async {
  var pendingNotificationRequests =
      await todoForm.notifications.pendingNotificationRequests();
  return pendingNotificationRequests;
}

void cancelNotification(int id) async {
  notificationsController.value
      .removeWhere((notification) => notification.id == id);
  await todoForm.notifications.cancel(id);
}

void cancelAllNotifications() async {
  notificationsController.value.clear();
  await todoForm.notifications.cancelAll();
}

void scheduleNotification(Todo todo) async {
  var scheduledNotificationDateTime = todo.reminderDateTime;
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "your other channel id",
      "your other channel name",
      "your other channel description");
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await todoForm.notifications.schedule(
    todo.id,
    todo.title,
    "",
    scheduledNotificationDateTime,
    platformChannelSpecifics,
    payload: todo.id.toString(),
  );
  addNotificationController(todo);
}

void scheduleNotificationDaily(Todo todo) async {
  var time = Time(todo.reminderDateTime.hour, todo.reminderDateTime.minute,
      todo.reminderDateTime.second);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await todoForm.notifications.showDailyAtTime(
    todo.id,
    todo.title,
    "",
    time,
    platformChannelSpecifics,
    payload: todo.id.toString(),
  );
  addNotificationController(todo);
}

void scheduleNotificationWeekly(Todo todo) async {
  var time = Time(todo.reminderDateTime.hour, todo.reminderDateTime.minute,
      todo.reminderDateTime.second);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await todoForm.notifications.showWeeklyAtDayAndTime(
    todo.id,
    todo.title,
    "",
    Day.values[todo.daysToRemind.indexWhere((day) => day)],
    time,
    platformChannelSpecifics,
    payload: todo.id.toString(),
  );
  addNotificationController(todo);
}

void showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "your channel id", "your channel name", "your channel description",
      importance: Importance.Max, priority: Priority.High, ticker: "ticker");
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await todoForm.notifications.show(0, "Hello this is the title",
      "From Work Manager", platformChannelSpecifics,
      payload: "item x");
}

// void showNotificationWithNoBody() async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       "your channel id", "your channel name", "your channel description",
//       importance: Importance.Max, priority: Priority.High, ticker: "ticker");
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//   await todoForm.notifications.show(
//       0, "plain title", null, platformChannelSpecifics,
//       payload: "item x");
// }

// void showNotificationWithNoSound() async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       "silent channel id", "silent channel name", "silent channel description",
//       playSound: false, styleInformation: DefaultStyleInformation(true, true));
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: false);
//   var platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//   await todoForm.notifications.show(
//       0, "<b>silent</b> title", "<b>silent</b> body", platformChannelSpecifics);
// }
