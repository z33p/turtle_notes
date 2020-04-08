import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  final TextEditingController titleController;

  TitleField(this.titleController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text("Título"),
          ),
          TextFormField(
            controller: titleController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
