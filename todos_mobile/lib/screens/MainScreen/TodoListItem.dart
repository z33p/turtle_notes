import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/helpers/TodosProvider.dart';
import 'package:todos_mobile/helpers/datetime.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoFormScreen.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/DaysToRemindField.dart';

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

  void deleteTodo() {
    setState(() {
      isBeingRemoved = false;
      removed = false;
    });
    store.dispatch(deleteTodoAction(widget.todo.id));
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
      if (removed) deleteTodo();
      // If not removed it should show because is beign removed
      return SizedBox.shrink();
    }

    return Dismissible(
      key: Key(widget.todo.id.toString()),
      onDismissed: (direction) {
        setState(() => isBeingRemoved = true);
        showSnackBar(context);
      },
      background: dismissibleBackground(),
      child: Card(
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoFormScreen(
                  title: widget.todo.title,
                  todo: widget.todo,
                  isReadingTodo: true,
                ),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              ListTile(
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
                  onPressed: () async {
                    // It ends the current Snackbar (if there's one) avoiding memory leak warning
                    Scaffold.of(context).hideCurrentSnackBar();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoFormScreen(
                          title: "Editar Tarefa",
                          todo: widget.todo,
                          isUpdatingTodo: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.todo.daysToRemind
                      .asMap()
                      .entries
                      .map(
                        (day) => Container(
                          padding: EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              color: widget.todo.daysToRemind[day.key]
                                  ? Colors.grey
                                  : Colors.white,
                              // borderRadius:
                              //     BorderRadius.all(Radius.circular(360)),
                              border:
                                  Border.all(color: Colors.grey, width: 1.0)),
                          child: Text(
                            weekDaysLabels[day.key],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: widget.todo.daysToRemind[day.key]
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Criado: " +
                        swapDayFieldAndYearField(
                            widget.todo.createdAt.toString().split(".")[0]),
                    style: TextStyle(fontSize: 11.0),
                  ),
                  Text(
                      "Atualizado: " +
                          swapDayFieldAndYearField(
                              widget.todo.updatedAt.toString().split(".")[0]),
                      style: TextStyle(fontSize: 11.0)),
                ],
              )
            ],
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
