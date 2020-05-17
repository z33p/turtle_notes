import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import 'package:turtle_notes/helpers/notifications_provider.dart';
import 'package:turtle_notes/models/Notification.dart';
import "package:turtle_notes/models/Todo.dart";

import 'notifications_provider.dart';

final String tableTodos = "todos";
final String columnId = "id";
final String columnTitle = "title";
final String columnTodoTitle = "todoTitle";
final String columnDescription = "description";
final String columnIsDone = "isDone";
final String columnTimePeriods = "timePeriodsTo";
final String columnReminderDateTime = "reminderDateTime";
final String columnDaysToRemind = "daysToRemind";
final String columnCreatedAt = "createdAt";
final String columnUpdatedAt = "updatedAt";

final String tableNotifications = "notifications";
final String columnTodoId = "todoId";
final String columnRepeatInterval = "repeatInterval";

class TodosProvider {
  TodosProvider._();
  static final TodosProvider db = TodosProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // await deleteDatabase(join(await getDatabasesPath(), "todos.db"));
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), "todos.db"),
      onCreate: (db, version) {
        db.execute(
          """
          CREATE TABLE IF NOT EXISTS $tableTodos(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT,
            $columnIsDone INTEGER,
            $columnTimePeriods TEXT NOT NULL,
            $columnReminderDateTime TEXT,
            $columnDaysToRemind TEXT,
            $columnCreatedAt TEXT,
            $columnUpdatedAt TEXT
          );
        """,
        );
        db.execute("""
          CREATE TABLE IF NOT EXISTS $tableNotifications(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnRepeatInterval TEXT,
            $columnTodoId INTEGER NOT NULL,
            FOREIGN KEY($columnTodoId)
            REFERENCES $tableTodos($columnId)
            ON DELETE CASCADE ON UPDATE CASCADE
          );
          """);
      },
      version: 1,
    );
  }

  Future close() async => (await database).close();

  Future<Todo> find(int id) async {
    final db = await database;

    List<Map<String, dynamic>> todos =
        await db.query(tableTodos, where: "$columnId = $id");

    Map<String, dynamic> todo = {
      ...todos[0],
      tableNotifications:
          await db.query(tableNotifications, where: "$columnTodoId = $id")
    };

    return Todo.fromMap(todo);
  }

  Future<List<Todo>> findAll() async {
    final db = await database;

    List<Map<String, dynamic>> todosListMap = await db.query(tableTodos);

    var todos = await Future.wait(todosListMap.map((todoMap) async {
      Map<String, dynamic> todoMapWithNotifications = {
        ...todoMap,
        tableNotifications: await db.query(tableNotifications,
            where: "$columnTodoId = ${todoMap[columnId]}")
      };

      return Todo.fromMap(todoMapWithNotifications);
    }).toList());

    return todos;
  }

  Future<Todo> insert(Todo todo) async {
    final db = await database;
    todo.createdAt = DateTime.now();
    todo.updatedAt = DateTime.now();
    todo.id = await db.insert(tableTodos, todo.toMap());
    db.insert(tableNotifications, {columnTodoId: todo.id});
    return todo;
  }

  Future<int> update(Todo todo) async {
    final db = await database;

    return await db.update(tableTodos, todo.toMap(),
        where: "$columnId = ${todo.id}");
  }

  Future<int> patch(int id, Map todo) async {
    final db = await database;

    return await db.update(tableTodos, todo, where: "$columnId = $id");
  }

  Future<int> remove(Todo todo) async {
    final db = await database;
    todo.notifications.forEach((notification) {
      cancelNotification(notification.id);
    });
    return await db.delete(tableTodos, where: "$columnId = ${todo.id}");
  }

  Future<Notification> insertNotification(
      int todoId, Notification notification) async {
    final db = await database;
    notification.id = await db.insert(tableNotifications, {
      columnTodoId: todoId,
    });
    return notification;
  }

  Future<int> removeNotification(int id) async {
    final db = await database;
    cancelNotification(id);
    return await db.delete(tableNotifications, where: "$columnId = $id");
  }
}
