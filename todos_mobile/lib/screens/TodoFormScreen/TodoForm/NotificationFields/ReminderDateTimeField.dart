import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:todos_mobile/models/Todo.dart';

import '../TodoForm.dart';

class ReminderDateTimeField extends StatelessWidget {
  ReminderDateTimeField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text("Horário"),
        ),
        ValueListenableBuilder<bool>(
            valueListenable: todoForm.isReadingTodoController,
            builder: (BuildContext context, bool isReadingTodo, _) {
              if (todoForm.selectedTimePeriod.value != TimePeriods.NEVER &&
                  todoForm.selectedTimePeriod.value != TimePeriods.MONTHLY)
                return GestureDetector(
                  onTap: () => todoForm.isReadingTodo = false,
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      ignoring: isReadingTodo,
                      child: DateTimeField(
                        controller: todoForm.reminderDateTimeController,
                        enabled: !isReadingTodo,
                        textAlign: TextAlign.center,
                        format: DateFormat("HH:mm"),
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ??
                                DateFormat("dd-MM-yyyy HH:mm").parse(
                                    todoForm.reminderDateTimeController.text)),
                          );
                          return DateTimeField.convert(time);
                        },
                      ),
                    ),
                  ),
                );
              else
                return GestureDetector(
                  onTap: () => todoForm.isReadingTodo = false,
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      ignoring: isReadingTodo,
                      child: DateTimeField(
                        controller: todoForm.reminderDateTimeController,
                        enabled: !isReadingTodo,
                        textAlign: TextAlign.center,
                        format: DateFormat("dd-MM-yyyy HH:mm"),
                        onChanged: (value) {
                          if (todoForm.isReadingTodoController.value)
                            todoForm.isReadingTodo = false;
                        },
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ??
                                  DateFormat("dd-MM-yyyy HH:mm").parse(
                                      todoForm.reminderDateTimeController.text),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ??
                                      DateFormat("dd-MM-yyyy HH:mm").parse(
                                          todoForm.reminderDateTimeController
                                              .text)),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                    ),
                  ),
                );
            })
      ],
    );
  }
}
