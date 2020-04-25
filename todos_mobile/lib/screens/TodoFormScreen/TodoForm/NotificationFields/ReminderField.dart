import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';

class ReminderField extends StatefulWidget {
  final TextEditingController reminderController;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  ReminderField(this.reminderController, this.setIsReadingTodoState);

  @override
  _ReminderFieldState createState() => _ReminderFieldState();
}

class _ReminderFieldState extends State<ReminderField> {
  bool isToRemind = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text("Horário"),
        ),
        DateTimeField(
          textAlign: TextAlign.center,
          controller: widget.reminderController,
          format: DateFormat("dd-MM-yyyy HH:mm"),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
        ),
      ],
    );
  }
}
