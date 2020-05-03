import 'package:flutter/material.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/TimePeriodsField.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/TodoForm.dart';

class DaysToRemindField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: WeekDays.values
              .map(
                (WeekDays day) => ValueListenableBuilder<bool>(
                    valueListenable: todoForm.daysToRemindController[day.index],
                    builder: (BuildContext context, bool dayToRemind, _) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                        width: MediaQuery.of(context).size.width / 10,
                        child: FlatButton(
                          padding: EdgeInsets.all(0.0),
                          shape: CircleBorder(),
                          onPressed: () {
                            if (todoForm.isReadingTodoController.value)
                              todoForm.isReadingTodo = false;

                            todoForm.setDaysToRemind(
                              index: day.index,
                              value: !dayToRemind,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: todoForm
                                        .daysToRemindController[day.index].value
                                    ? Colors.teal
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(360)),
                                border:
                                    Border.all(color: Colors.blue, width: 1.0)),
                            child: Text(
                              day.label,
                              style: TextStyle(
                                  color: todoForm
                                          .daysToRemindController[day.index]
                                          .value
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
              )
              .toList()),
    );
  }
}
