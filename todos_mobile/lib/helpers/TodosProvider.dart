import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import 'package:todos_mobile/helpers/notifications_provider.dart';
import "package:todos_mobile/models/Todo.dart";

final String tableName = "todos";
final String columnId = "id";
final String columnTitle = "title";
final String columnDescription = "description";
final String columnIsDone = "isDone";
final String columnTimePeriods = "timePeriodsTo";
final String columnReminderDateTime = "reminderDateTime";
final String columnDaysToRemind = "daysToRemind";
final String columnCreatedAt = "createdAt";
final String columnUpdatedAt = "updatedAt";

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
        return db.execute(
          """
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT,
            $columnIsDone INTEGER,
            $columnTimePeriods TEXT NOT NULL,
            $columnReminderDateTime TEXT,
            $columnDaysToRemind TEXT,
            $columnCreatedAt TEXT,
            $columnUpdatedAt TEXT
          )
        """,
        );
      },
      version: 1,
    );
  }

  Future close() async => (await database).close();

  Future<Todo> find(int id) async {
    final db = await database;

    List<Map> todos = await db.query(tableName, where: "$columnId = $id");

    return Todo.fromMap(todos[0]);
  }

  Future<List<Todo>> findAll() async {
    final db = await database;

    List<Map> todos = await db.query(tableName);

    return todos.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<Todo> insert(Todo todo) async {
    final db = await database;
    todo.createdAt = DateTime.now();
    todo.updatedAt = DateTime.now();
    todo.id = await db.insert(tableName, todo.toMap());
    return todo;
  }

  Future<int> update(Todo todo) async {
    final db = await database;

    return await db.update(tableName, todo.toMap(),
        where: "$columnId = ${todo.id}");
  }

  Future<int> patch(int id, Map todo) async {
    final db = await database;

    return await db.update(tableName, todo, where: "$columnId = $id");
  }

  Future<int> remove(int id) async {
    final db = await database;
    cancelNotification(id);
    return await db.delete(tableName, where: "$columnId = $id");
  }
}
