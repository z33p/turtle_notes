import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:turtle_notes/helpers/TodosProvider.dart';
import 'package:turtle_notes/helpers/notifications_provider.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/screens/MainScreen/TimeLeft.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoFormScreen.dart';

class NotificationsView extends StatelessWidget {
  final List<Todo> todos;

  NotificationsView(this.todos);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PendingNotificationRequest>>(
        valueListenable: notificationsController,
        builder: (BuildContext context, notifications, Widget _) {
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
                  Todo todo =
                      todos.firstWhere((todo) => todo.id == notification.id);

                  return PopupMenuItem<int>(
                    height: 0,
                    value: notification.id,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      leading: Icon(
                        Icons.notifications_active,
                        color: Colors.green,
                      ),
                      title: Text(
                        notification.title,
                      ),
                      subtitle: TimeLeft(todo),
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
        });
  }
}
