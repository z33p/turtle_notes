import 'package:turtle_notes/models/Todo.dart';

class GetTodosAction {
  final List<Todo> todos;

  GetTodosAction(this.todos);
}

class CreateTodoAction {
  final Todo todo;

  CreateTodoAction(this.todo);
}

class UpdateTodoAction {
  final Todo todo;

  UpdateTodoAction(this.todo);
}

class PatchTodoAction {
  final int id;
  final Map<String, dynamic> todo;

  PatchTodoAction(this.id, this.todo);
}

class DeleteTodoAction {
  final int id;

  DeleteTodoAction(this.id);
}

enum TodosActionTypes { GET_TODOS }
