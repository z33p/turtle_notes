import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:turtle_notes/models/Notification.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoForm/TodoForm.dart';

import '../models/Todo.dart';
import 'TodosProvider.dart';

Future<List<Notification>> setNotifications(Todo todo,
    {bool todoExists = false}) async {
  if (todo.timePeriods == TimePeriods.CHOOSE_DAYS) {
    if (todoExists) {
      cancelEachNotification(todo.notifications);

      int amountOfPendingNotifications = 0;

      await Future.forEach(todo.daysToRemind.asMap().keys, (index) async {
        if (todo.daysToRemind[index]) {
          if (todo.notifications.length > amountOfPendingNotifications) {
            scheduleNotificationWeekly(
                todo.notifications[amountOfPendingNotifications].id,
                index,
                todo);
            amountOfPendingNotifications++;
          } else {
            var notification = await TodosProvider.db
                .insertNotification(todo.id, Notification());
            todo.notifications.add(notification);
            scheduleNotificationWeekly(notification.id, index, todo);
            amountOfPendingNotifications++;
          }
        }
      });

      for (var i = todo.notifications.length - 1;
          todo.notifications.length > amountOfPendingNotifications;
          i--) {
        TodosProvider.db.removeNotification(todo.notifications[i].id);
        todo.notifications.removeLast();
      }
    } else {
      await Future.forEach(todo.daysToRemind.asMap().keys, (index) async {
        if (todo.daysToRemind[index]) {
          var notification = await TodosProvider.db
              .insertNotification(todo.id, Notification());
          todo.notifications.add(notification);
          scheduleNotificationWeekly(notification.id, index, todo);
        }
      });
    }

    return todo.notifications;
  }

  if (todoExists) {
    cancelEachNotification(todo.notifications);

    for (var i = todo.notifications.length - 1; i > 0; i--) {
      TodosProvider.db.removeNotification(todo.notifications[i].id);
      todo.notifications.removeLast();
    }

    switch (todo.timePeriods) {
      case TimePeriods.DAILY:
        scheduleNotificationDaily(todo.notifications[0].id, todo);
        return todo.notifications;

      case TimePeriods.WEEKLY:
        scheduleNotification(todo.notifications[0].id, todo);
        return todo.notifications;

      default:
        // Case TimePeriods.Never
        if (todo.reminderDateTime.difference(DateTime.now()).isNegative)
          return todo.notifications;

        scheduleNotification(todo.notifications[0].id, todo);
        return todo.notifications;
    }
  }

  switch (todo.timePeriods) {
    case TimePeriods.DAILY:
      var notification =
          await TodosProvider.db.insertNotification(todo.id, Notification());
      scheduleNotificationDaily(notification.id, todo);

      return [notification];

    case TimePeriods.WEEKLY:
      var notification =
          await TodosProvider.db.insertNotification(todo.id, Notification());
      scheduleNotificationWeekly(
          notification.id, todo.daysToRemind.indexWhere((day) => day), todo);

      return [notification];

    default:
      // Case TimePeriods.Never
      var notification =
          await TodosProvider.db.insertNotification(todo.id, Notification());

      if (todo.reminderDateTime.difference(DateTime.now()).isNegative)
        return [notification];

      scheduleNotification(notification.id, todo);
      return [notification];
  }
}

Future<List<PendingNotificationRequest>>
    checkPendingNotificationRequests() async {
  var pendingNotificationRequests =
      await todoForm.notifications.pendingNotificationRequests();
  return pendingNotificationRequests;
}

void cancelEachNotification(List<Notification> notifications) {
  notifications.forEach((notification) {
    todoForm.notifications.cancel(notification.id);
  });
}

void cancelAllNotifications() async {
  await todoForm.notifications.cancelAll();
}

void scheduleNotification(int notificationID, Todo todo) async {
  var scheduledNotificationDateTime = todo.reminderDateTime;
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "your other channel id",
      "your other channel name",
      "your other channel description");
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await todoForm.notifications.schedule(
    notificationID,
    todo.title,
    "",
    scheduledNotificationDateTime,
    platformChannelSpecifics,
    payload: todo.id.toString(),
  );
}

void scheduleNotificationDaily(int notificationID, Todo todo) async {
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
    notificationID,
    todo.title,
    "",
    time,
    platformChannelSpecifics,
    payload: todo.id.toString(),
  );
}

void scheduleNotificationWeekly(
    int notificationID, int dayToRemindIndex, Todo todo) async {
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
    notificationID,
    todo.title,
    "",
    Day.values[dayToRemindIndex],
    time,
    platformChannelSpecifics,
    payload: todo.id.toString(),
  );
}

void showNotification(int notificationID) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "your channel id", "your channel name", "your channel description",
      importance: Importance.Max, priority: Priority.High, ticker: "ticker");
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await todoForm.notifications.show(
      notificationID, "Hello this is the title", null, platformChannelSpecifics,
      payload: "item x");
}
