import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class DateChooser extends StatefulWidget {
  const DateChooser({super.key, required this.replaceTaskList});

  final ValueSetter<DateTime> replaceTaskList;

  @override
  State<DateChooser> createState() => _DateChooserState();
}

class _DateChooserState extends State<DateChooser> {
  @override
  void initState() {
    chosenDate = DateTime.now();
    super.initState();
  }

  var _chosenDate = DateTime.now();

  set chosenDate(newDate) {
    setState(() {
      _chosenDate = newDate;
    });
    widget.replaceTaskList(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.calendar_month),
      Text('Date:', style: Theme.of(context).textTheme.headline6),
      TextButton(
          onPressed: () {
            DatePicker.showDatePicker(context, onConfirm: (date) {
              chosenDate = date;
            },
                currentTime: _chosenDate,
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
          child: Text(DateFormat('dd-MM-yyyy').format(_chosenDate),
              style: Theme.of(context).textTheme.headline6))
    ]);
  }
}
