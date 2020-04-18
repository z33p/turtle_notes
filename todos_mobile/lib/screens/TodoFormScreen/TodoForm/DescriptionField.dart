import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController descriptionController;

  DescriptionField(this.descriptionController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text("Descrição"),
          ),
          TextFormField(
            controller: descriptionController,
            maxLines: 4,
          )
        ],
      ),
    );
  }
}
