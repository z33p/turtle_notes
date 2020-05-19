import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:turtle_notes/helpers/notifications_provider.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/screens/MainScreen/NotificationsList/NotificationsView.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoFormScreen.dart';

class NotificationsList extends StatefulWidget {
  final List<Todo> todos;
  final List<Todo> validTodosNotification = [];

  NotificationsList(this.todos) {
    todos.forEach((todo) {
      if (todo.timePeriods == TimePeriods.NEVER &&
              todo.reminderDateTime.difference(DateTime.now()).isNegative ||
          todo.isDone) return;
      validTodosNotification.add(todo);
    });
  }

  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  List<PendingNotificationRequest> pendingNotifications = [];
  List<PendingNotificationRequest> copyPendingNotifications = [];

  getPedingNotifications() async {
    // cancelAllNotifications();
    var pendingNotifications = await checkPendingNotificationRequests();
    // pendingNotifications.forEach((notification) {
    //   print(notification.payload);
    // });
    setState(() {
      this.pendingNotifications = pendingNotifications;
    });
  }

  bool checkPendingIsActive(Todo todo) {
    int firstOcurrencyIndex =
        pendingNotifications.indexWhere((n) => int.parse(n.payload) == todo.id);
    bool isActive = firstOcurrencyIndex > -1;
    if (isActive) {
      int lastOcurrency = firstOcurrencyIndex + 1;

      while (lastOcurrency < pendingNotifications.length) {
        if (int.parse(pendingNotifications[lastOcurrency].payload) != todo.id) {
          break;
        }
        lastOcurrency++;
      }

      pendingNotifications.removeRange(firstOcurrencyIndex, lastOcurrency);
    }

    return isActive;
  }

  @override
  void initState() {
    super.initState();
    getPedingNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        widget.validTodosNotification.length == 0
            ? Icons.notifications_none
            : Icons.notifications_active,
        color: Colors.white,
      ),
      onSelected: (id) async {
        Todo todo = widget.todos.firstWhere((todo) => todo.id == id);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoFormScreen(
              title: todo.title,
              todo: todo,
              isReadingTodo: true,
            ),
          ),
        );
      },
      itemBuilder: (BuildContext context) {
        getPedingNotifications();
        return widget.validTodosNotification.map(
          (todo) {
            return PopupMenuItem<int>(
              height: 0,
              value: todo.id,
              child: NotificationsView(todo, checkPendingIsActive),
            );
          },
        ).toList();
      },
    );
  }
}
