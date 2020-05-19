import 'package:flutter/material.dart';
import 'package:turtle_notes/helpers/notifications_provider.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/screens/MainScreen/NotificationsList/TimeLeft.dart';

class NotificationsView extends StatefulWidget {
  final Todo todo;
  final bool Function(Todo todo) checkPendingIsActive;

  NotificationsView(
    this.todo,
    this.checkPendingIsActive,
  );

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive = widget.checkPendingIsActive(widget.todo);
  }

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return ListTile(
        contentPadding: EdgeInsets.all(3.0),
        title: Text(
          widget.todo.title,
        ),
        subtitle: TimeLeft(widget.todo),
        trailing: IconButton(
          icon: Icon(
            Icons.notifications_active,
            color: Colors.green,
          ),
          onPressed: () {
            cancelEachNotification(widget.todo.notifications);
            setState(() => isActive = false);
          },
        ),
      );
    }
    return ListTile(
      contentPadding: EdgeInsets.all(3.0),
      title: Text(
        widget.todo.title,
      ),
      subtitle: Text("zZzzZz"),
      trailing: IconButton(
        icon: Icon(
          Icons.notifications_paused,
          color: Colors.grey,
        ),
        onPressed: () {
          setNotifications(widget.todo, todoExists: true);
          setState(() => isActive = false);
        },
      ),
    );
  }
}
