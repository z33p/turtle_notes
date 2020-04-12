import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormActionButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final bool isUpdatingTodo;
  final void Function(BuildContext context) createOrEditTodo;

  FormActionButton(this._formKey, this.isUpdatingTodo, this.createOrEditTodo);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.arrow_forward),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          createOrEditTodo(context);
          Scaffold.of(context).showSnackBar(SnackBar(
              content:
                  Text(isUpdatingTodo ? "Todo editado!" : "Todo criado!")));

          await Future.delayed(
            Duration(seconds: 1),
            () => Navigator.pop(context),
          );
        }
      },
    );
  }
}
