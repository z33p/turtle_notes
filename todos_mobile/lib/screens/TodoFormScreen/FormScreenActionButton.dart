import 'package:flutter/material.dart';

class FormScreenActionButton extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final Future<void> Function() createOrEditTodo;
  final bool isUpdatingTodo;
  final bool isReadingTodo;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;
  final VoidCallback popNavigator;

  FormScreenActionButton(
    this._formKey,
    this.createOrEditTodo,
    this.isUpdatingTodo,
    this.isReadingTodo,
    this.setIsReadingTodoState,
    this.popNavigator,
  );

  @override
  _FormScreenActionButtonState createState() => _FormScreenActionButtonState();
}

class _FormScreenActionButtonState extends State<FormScreenActionButton> {
  bool itWasBeingRead;
  IconData saveOrArrowIcon;

  @override
  void initState() {
    super.initState();
    itWasBeingRead = widget.isReadingTodo;
    saveOrArrowIcon = widget.isReadingTodo ? Icons.save : Icons.arrow_forward;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // child: Text("${isReadingTodo ? 1 : 0} ${isUpdatingTodo ? 1 : 0}"),
      child: Icon(widget.isReadingTodo ? Icons.edit : saveOrArrowIcon),
      onPressed: () async {
        if (widget.isReadingTodo) {
          widget.setIsReadingTodoState(false);
          return;
        }

        if (widget._formKey.currentState.validate()) {
          await widget.createOrEditTodo();
          int snackBarDuration = 1;
          Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: snackBarDuration),
              content: Text(
                widget.isUpdatingTodo ? "Tarefa editada!" : "Tarefa criada!",
              )));

          await Future.delayed(
            Duration(seconds: snackBarDuration),
            itWasBeingRead
                ? () => widget.setIsReadingTodoState(true)
                : widget.popNavigator,
          );
        }
      },
    );
  }
}
