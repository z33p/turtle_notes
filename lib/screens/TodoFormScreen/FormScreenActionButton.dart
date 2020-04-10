import 'package:flutter/material.dart';

class FormScreenActionButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final Future<void> Function() createOrEditTodo;
  final bool isUpdatingTodo;
  final VoidCallback popNavigator;

  FormScreenActionButton(this._formKey, this.createOrEditTodo,
      this.isUpdatingTodo, this.popNavigator);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.arrow_forward),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          await createOrEditTodo();
          int snackBarDuration = 1;
          Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: snackBarDuration),
              content: Text(
                isUpdatingTodo ? "Todo editado!" : "Todo criado!",
              )));

          await Future.delayed(
            Duration(seconds: snackBarDuration),
            popNavigator,
          );
        }
      },
    );
  }
}
