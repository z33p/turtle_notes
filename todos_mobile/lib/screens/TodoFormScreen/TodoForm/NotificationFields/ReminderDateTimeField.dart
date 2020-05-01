import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:todos_mobile/models/Todo.dart';

class ReminderDateTimeField extends StatelessWidget {
  final TimePeriods selectedTimePeriod;
  final TextEditingController timePeriodsController;

  final bool isReadingTodo;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  ReminderDateTimeField(
    this.selectedTimePeriod,
    this.timePeriodsController,
    this.isReadingTodo,
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
            controller: timePeriodsController,
            format: DateFormat("HH:mm"),
            onChanged: (value) {
              if (isReadingTodo) setIsReadingTodoState(false);
            },
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(currentValue ??
                    DateFormat("dd-MM-yyyy HH:mm")
                        .parse(timePeriodsController.text)),
              );
              return DateTimeField.convert(time);
            },
          )
        else
          DateTimeField(
            textAlign: TextAlign.center,
            controller: timePeriodsController,
            format: DateFormat("dd-MM-yyyy HH:mm"),
            onChanged: (value) {
              if (isReadingTodo) setIsReadingTodoState(false);
            },
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ??
                      DateFormat("dd-MM-yyyy HH:mm")
                          .parse(timePeriodsController.text),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(currentValue ??
                      DateFormat("dd-MM-yyyy HH:mm")
                          .parse(timePeriodsController.text)),
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
