import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:turtle_notes/actions/todos_actions.dart';
import 'package:turtle_notes/helpers/TodosProvider.dart';
import 'package:turtle_notes/screens/MainScreen/MainScreen.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoForm/TodoForm.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoFormScreen.dart';
import 'package:turtle_notes/store.dart';

import 'models/Todo.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key) {
    getTodosAction(store);
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    todoForm.notifications = notifications;

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings();

    notifications.initialize(
      InitializationSettings(settingsAndroid, settingsIOS),
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) async {
    print(payload);
    Todo todo = await TodosProvider.db.find(int.parse(payload));

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
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: "Tarefas",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
        ),
        home: StoreConnector<AppState, List<Todo>>(
          converter: (store) => store.state.todos,
          builder: (context, todos) => MainScreen(
            todos,
            title: "Tarefas",
          ),
        ),
      ),
    );
  }
}
