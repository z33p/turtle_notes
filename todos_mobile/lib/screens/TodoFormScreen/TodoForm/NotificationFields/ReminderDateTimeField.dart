import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:todos_mobile/models/Todo.dart';

class ReminderDateTimeField extends StatelessWidget {
  final TimePeriods selectedTimePeriod;

  final TextEditingController reminderDateTimeController;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  ReminderDateTimeField(
    this.selectedTimePeriod,
    this.reminderDateTimeController,
    this.setIsReadingTodoState,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text("Horário"),
        ),
        if (selectedTimePeriod != TimePeriods.NEVER &&
            selectedTimePeriod != TimePeriods.MONTHLY)
          DateTimeField(
            textAlign: TextAlign.center,
            controller: reminderDateTimeController,
            format: DateFormat("HH:mm"),
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(currentValue ??
                    DateFormat("dd-MM-yyyy hh:mm")
                        .parse(reminderDateTimeController.text)),
              );
              return DateTimeField.convert(time);
            },
          )
        else
          DateTimeField(
            textAlign: TextAlign.center,
            controller: reminderDateTimeController,
            format: DateFormat("dd-MM-yyyy HH:mm"),
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ??
                      DateFormat("dd-MM-yyyy hh:mm")
                          .parse(reminderDateTimeController.text),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(currentValue ??
                      DateFormat("dd-MM-yyyy hh:mm")
                          .parse(reminderDateTimeController.text)),
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
