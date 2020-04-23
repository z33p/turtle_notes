import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoFormScreen.dart';

import '../../store.dart';
import 'TodoListItem.dart';

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
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoFormScreen()),
          );
        }),
        tooltip: "Criar Todo",
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async => getTodosAction(store),
        child: ListView(
          children: todos.map((todo) => TodoListItem(todo)).toList(),
        ),
      ),
    );
  }
}
