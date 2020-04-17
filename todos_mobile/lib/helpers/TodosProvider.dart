import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:todos_mobile/models/Todo.dart";

final String tableName = 'todos';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDescription = 'description';
final String columnIsDone = 'isDone';
final String columnCreatedAt = 'createdAt';
final String columnUpdatedAt = 'updatedAt';

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
            $columnTitle TEXT NOT null,
            $columnDescription TEXT,
            $columnIsDone INTEGER,
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

  Future<List<Todo>> findAll() async {
    final db = await database;

    List<Map> maps = await db.query(tableName);

    return maps.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<Todo> insert(Todo todo) async {
    final db = await database;
    todo.createdAt = DateTime.now().toString();
    todo.updatedAt = DateTime.now().toString();
    todo.id = await db.insert(tableName, todo.toMap());
    return todo;
  }

  Future<int> update(Todo todo) async {
    final db = await database;
    todo.updatedAt = DateTime.now().toString();

    return await db.update(tableName, todo.toMap(),
        where: "$columnId = ${todo.id}");
  }

  Future<int> patch(int id, Map todo) async {
    final db = await database;
    todo[columnUpdatedAt] = DateTime.now().toString();

    return await db.update(tableName, todo, where: "$columnId = $id");
  }

  Future<int> remove(int id) async {
    final db = await database;
    return await db.delete(tableName, where: "$columnId = $id");
  }
}
