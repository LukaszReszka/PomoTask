import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pomo_task/constants.dart';

class TodoListHeader extends StatefulWidget {
  const TodoListHeader({super.key}); //TODO callback by ogarnąć listę

  @override
  State<TodoListHeader> createState() => _TodoListHeaderState();
}

class _TodoListHeaderState extends State<TodoListHeader> {
  var _chosenStartTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return _getTodoListHeader();
  }

  Row _getTodoListHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.access_time_filled),
      Text('Start time:', style: Theme.of(context).textTheme.headline6),
      TextButton(
          onPressed: () {
            DatePicker.showTimePicker(context, onConfirm: (date) {
              setState(() {
                _chosenStartTime = date;
              });
            },
                currentTime: _chosenStartTime,
                showSecondsColumn: false,
                theme: const DatePickerTheme(
                    doneStyle: TextStyle(
                        color: majorColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    itemStyle: TextStyle(
                        color: majorColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)));
          },
          child: Text(DateFormat('HH:mm').format(_chosenStartTime),
              style: Theme.of(context).textTheme.headline6)),
      const SizedBox(width: 150),
      CircleAvatar(
          backgroundColor: majorColor,
          child: IconButton(
            onPressed: () {}, //TODO launch pomodoro timer
            color: Colors.white,
            icon: const Icon(
              Icons.rocket_launch,
            ),
          ))
    ]);
  }
}
