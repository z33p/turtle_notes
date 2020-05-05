import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/helpers/notifications_provider.dart';
import 'package:todos_mobile/models/Todo.dart';

import '../../store.dart';
import '../TodoFormScreen/TodoFormScreen.dart';
import 'NotificationsViewButton.dart';
import 'TodoList/TodoList.dart';

class MainScreen extends StatefulWidget {
  final String title;
  final List<Todo> todos;
  final VoidCallback getTodos;

  MainScreen(this.todos, {Key key, this.title, this.getTodos})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<PendingNotificationRequest> notifications;

  @override
  void initState() {
    super.initState();
    notifications = [];
    getNotifications();
  }

  Future<void> getNotifications() async {
    var notificationsPending = await checkPendingNotificationRequests();
    setState(() => notifications = notificationsPending);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.title),
            NotificationsViewButton(notifications)
          ],
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
        child: TodoList(widget.todos),
      ),
    );
  }
}
