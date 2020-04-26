import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/MainScreen/TodoListItens/TodoList.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoFormScreen.dart';

import '../../store.dart';

class MainScreen extends StatelessWidget {
  final String title;
  final List<Todo> todos;
  final VoidCallback getTodos;

  MainScreen(this.todos, {this.title = "Tarefas", this.getTodos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() async {
          // await NotificationsProvider.checkPendingNotificationRequests(context);
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoFormScreen()),
          );
        }),
        tooltip: "Criar Tarefa",
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async => getTodosAction(store),
        child: ListView(
          children: todos.map((todo) => TodoList(todo)).toList(),
        ),
      ),
    );
  }
}
