import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/TodoForm.dart';

void main() {
  group('Create Or Edit Todo Method', () {
    test(
        "[extractTodoFromFields] should set to remind daily when all [daysToRemindController] are true",
        () async {
      final todoForm = TodoForm();

      todoForm.selectedTimePeriod = ValueNotifier(TimePeriods.CHOOSE_DAYS);

      for (var i = 0; i < 7; i++) {
        todoForm.setDaysToRemind(index: i, value: true);
      }

      expect(todoForm.selectedTimePeriod.value, TimePeriods.DAILY);

      var todo = todoForm.extractTodoFromFields();

      for (var i = 0; i < 7; i++) {
        todoForm.setDaysToRemind(index: i, value: false);
      }

      expect(todo.timePeriods, TimePeriods.NEVER);
    });
  });
}
