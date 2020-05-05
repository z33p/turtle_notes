import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:todos_mobile/helpers/TodosProvider.dart';
import 'package:todos_mobile/helpers/notifications_provider.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoFormScreen.dart';

class NotificationsViewButton extends StatelessWidget {
  final List<PendingNotificationRequest> notifications;

  NotificationsViewButton(this.notifications);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        notifications.length == 0
            ? Icons.notifications_none
            : Icons.notifications_active,
        color: Colors.white,
      ),
      onSelected: (id) async {
        Todo todo = await TodosProvider.db.find(id);
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
        return notifications.map(
          (notification) {
            return PopupMenuItem<int>(
              height: 0,
              value: notification.id,
              child: ListTile(
                // contentPadding: EdgeInsets.all(0.0),
                leading: Icon(
                  Icons.notifications_active,
                  color: Colors.green,
                ),
                title: Text(
                  notification.title,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  onPressed: () => cancelNotification(notification.id),
                ),
              ),
            );
          },
        ).toList();
      },
    );
  }
}
