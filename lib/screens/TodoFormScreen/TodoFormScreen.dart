import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/FormActionButton.dart';
import 'TodoForm.dart';

class TodoFormScreen extends StatefulWidget {
  final String title;
  final Todo todo;
  final bool isUpdatingTodo;

  TodoFormScreen(
      {this.title = "Criar Todo", this.todo, this.isUpdatingTodo = false});

  @override
  _TodoFormScreenState createState() => _TodoFormScreenState(todo: todo);
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Todo todo;

  TextEditingController titleController;
  TextEditingController descriptionController;
  bool isDoneController;

  _TodoFormScreenState({this.todo}) {
    titleController = TextEditingController(text: this.todo?.title ?? "");
    descriptionController =
        TextEditingController(text: this.todo?.description ?? "");
    isDoneController = this.todo?.isDone ?? false;
  }

  @protected
  @mustCallSuper
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void setIsDone(bool value) {
    setState(() {
      isDoneController = value;
    });
  }

  final db = Firestore.instance.collection("todos");

  void createTodo(Map<String, dynamic> payload, Timestamp timestampNow) async {
    payload[columnCreatedAt] = timestampNow;
    await db.add(payload);
  }

  void updateTodo(Map<String, dynamic> payload) async {
    await db.document(this.todo.id).updateData(payload);
  }

  void createOrEditTodo(BuildContext context) async {
    Timestamp timestampNow = Timestamp.fromDate(DateTime.now());

    Map<String, dynamic> payload = {
      columnTitle: titleController.text,
      columnDescription: descriptionController.text,
      columnIsDone: isDoneController,
      columnUpdatedAt: timestampNow
    };

    if (widget.isUpdatingTodo) return updateTodo(payload);

    return createTodo(payload, timestampNow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FormActionButton(
          this._formKey, widget.isUpdatingTodo, createOrEditTodo),
      body: SingleChildScrollView(
        child: TodoForm(_formKey, titleController, descriptionController,
            isDoneController, setIsDone),
      ),
    );
  }
}
