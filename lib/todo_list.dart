import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key}); //TODO callback by ogarnąć listę

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var _chosenStartTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return _getTodoListHeader();
  }

  Row _getTodoListHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.access_alarm),
      Text('Start time:', style: Theme.of(context).textTheme.headline6),
      TextButton(
          onPressed: () {
            DatePicker.showTimePicker(context, onConfirm: (date) {
              setState(() {
                _chosenStartTime = date;
              });
            }, currentTime: _chosenStartTime, showSecondsColumn: false);
          },
          child: Text(DateFormat('HH:mm').format(_chosenStartTime),
              style: Theme.of(context).textTheme.headline6)),
    ]);
  }
}
