import 'package:flutter/material.dart';
import 'package:turtle_notes/helpers/notifications_provider.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/screens/MainScreen/TimeLeft.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoFormScreen.dart';

class NotificationsView extends StatelessWidget {
  final List<Todo> todos;
  final List<Todo> validTodosNotification = [];

  NotificationsView(this.todos) {
    todos.forEach((todo) {
      if (todo.timePeriods == TimePeriods.NEVER &&
          todo.reminderDateTime.difference(DateTime.now()).isNegative) return;
      validTodosNotification.add(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        validTodosNotification.length == 0
            ? Icons.notifications_none
            : Icons.notifications_active,
        color: Colors.white,
      ),
      onSelected: (id) async {
        Todo todo = todos.firstWhere((todo) => todo.id == id);
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
        return validTodosNotification.map(
          (todo) {
            return PopupMenuItem<int>(
              height: 0,
              value: todo.id,
              child: ListTile(
                contentPadding: EdgeInsets.all(3.0),
                leading: Icon(
                  Icons.notifications_active,
                  color: Colors.green,
                ),
                title: Text(
                  todo.title,
                ),
                subtitle: TimeLeft(todo),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  onPressed: () => cancelNotification(todo.id),
                ),
              ),
            );
          },
        ).toList();
      },
    );
  }
}
