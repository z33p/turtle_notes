import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/helpers/notifications_provider.dart';
import 'package:todos_mobile/models/Todo.dart';

import '../../store.dart';
import '../TodoFormScreen/TodoFormScreen.dart';
import 'NotificationsView.dart';
import 'TodoList/TodoList.dart';

class MainScreen extends StatelessWidget {
  final String title;
  final List<Todo> todos;
  final VoidCallback getTodos;

  MainScreen(this.todos, {Key key, this.title, this.getTodos})
      : super(key: key) {
    getNotifications();
  }

  Future<void> getNotifications() async {
    notificationsController.value = await checkPendingNotificationRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(title), NotificationsView(todos)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoFormScreen()),
          );
        }),
        tooltip: "Criar Tarefa",
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getTodosAction(store);
          getNotifications();
        },
        child: TodoList(todos),
      ),
    );
  }
}
