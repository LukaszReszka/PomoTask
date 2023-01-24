import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateChooser extends StatefulWidget {
  const DateChooser({super.key, required this.replaceTaskList});

  final VoidCallback replaceTaskList;

  @override
  State<DateChooser> createState() => _DateChooserState();
}

class _DateChooserState extends State<DateChooser> {
  var _chosenDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.calendar_month),
      Text('Date:', style: Theme.of(context).textTheme.headline6),
      TextButton(
          onPressed: () {
            DatePicker.showDatePicker(context, onConfirm: (date) {
              setState(() {
                _chosenDate = date;
              });
            }, currentTime: _chosenDate);
          },
          child: Text(DateFormat('dd-MM-yyy').format(_chosenDate),
              style: Theme.of(context).textTheme.headline6))
    ]);
  }
}
