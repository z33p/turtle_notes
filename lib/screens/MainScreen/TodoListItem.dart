import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/helpers/TodosProvider.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoFormScreen.dart';

import '../../store.dart';

class TodoListItem extends StatefulWidget {
  final Todo todo;

  TodoListItem(this.todo);

  @override
  _TodoListItemState createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  bool isBeingRemoved = false;
  bool removed = false;

  void setRemoved(bool value) {
    setState(() {
      removed = value;
    });
  }

  Widget dismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(Icons.delete, color: Colors.white),
    );
  }

  void showSnackBar(context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: DeleteTodoOnDeactivate(
          '"${widget.todo.title}" deletado.', setRemoved),
      action: SnackBarAction(
        label: "DESFAZER",
        onPressed: () => setState(() => isBeingRemoved = false),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (isBeingRemoved) {
      // If removed make a delete request
      if (removed) store.dispatch(deleteTodoAction(widget.todo.id));
      // If not removed it should show because is beign removed
      return SizedBox.shrink();
    }
    // If is not beign removed and removed variable is set to true it means user undo remove item
    // Therefore set removed to false to avoid bugs
    else if (removed) setRemoved(false);

    return Dismissible(
      key: Key(widget.todo.id.toString()),
      onDismissed: (direction) {
        setState(() => isBeingRemoved = true);
        showSnackBar(context);
      },
      background: dismissibleBackground(),
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: widget.todo.isDone,
            onChanged: (value) => store.dispatch(patchTodoAction(
                {columnId: widget.todo.id, columnIsDone: value ? 1 : 0})),
          ),
          title: Text(
            widget.todo.title.length < 20
                ? widget.todo.title
                : widget.todo.title.substring(0, 20) + "...",
            style: TextStyle(
                fontSize: 18,
                decoration: widget.todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          subtitle: Text(
            widget.todo.description == null
                ? ""
                : widget.todo.description.length < 50
                    ? widget.todo.description
                    : widget.todo.description.substring(0, 50) + "...",
            style: TextStyle(
                decoration: widget.todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // It ends the current Snackbar (if there's one) avoiding memory leak warning
              Scaffold.of(context).hideCurrentSnackBar();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoFormScreen(
                    title: "Editar Todo",
                    todo: widget.todo,
                    isUpdatingTodo: true,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DeleteTodoOnDeactivate extends StatefulWidget {
  final String text;
  final void Function(bool value) setRemoved;

  DeleteTodoOnDeactivate(this.text, this.setRemoved);

  @override
  _DeleteTodoOnDeactivateState createState() => _DeleteTodoOnDeactivateState();
}

class _DeleteTodoOnDeactivateState extends State<DeleteTodoOnDeactivate> {
  @protected
  @mustCallSuper
  void deactivate() async {
    // Set removed as true before dissapear thus if it is being removed it will be deleted
    widget.setRemoved(true);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.text);
  }
}
