import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:pomo_task/task.dart';
import 'package:pomo_task/time_settings_drawer.dart';
import 'package:pomo_task/todo_list_header.dart';

import 'calendar_client.dart';
import 'constants.dart';
import 'date_chooser.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.setNotLoggedInState});

  final VoidCallback setNotLoggedInState;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Task> _taskList = [];

  @override
  void initState() {
    replaceTasksList(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PomoTask'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DateChooser(replaceTaskList: replaceTasksList),
              //TODO metoda GroupLists
              const Divider(
                color: minorColor,
                thickness: 3,
              ),
              const TodoListHeader(),
              const SizedBox(height: 10),
              _getTodoList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Increment',
          child: const Icon(Icons.add_task),
        ),
        drawer: TimeSettingsDrawer(
          logoutAction: logout,
        ));
  }

  _incrementCounter() async {
    await GetIt.instance
        .get<CalendarClient>()
        .addEvent('Test', '2023-01-25 23:15', '2023-01-25 23:30', 1, 2);
  }

  _displayDialog(BuildContext context) async {
    var textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // _addTodoItem(textFieldController.text);
                },
              ),
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void logout() async {
    await GetIt.instance.get<CalendarClient>().logout();
    widget.setNotLoggedInState();
  }

  replaceTasksList(newDate) {
    GetIt.instance
        .get<CalendarClient>()
        .getEventsFromDay(newDate)
        .then((eventsList) {
      setState(() {
        _taskList = [];
        for (final Event event in eventsList) {
          if (event.description!.contains('Created by PomoTask ;)\nPomos: ')) {
            var splittedDescription = event.description!.split(' ');
            int pomosTotal =
                int.parse(splittedDescription[splittedDescription.length - 1]);
            int pomosDone =
                int.parse(splittedDescription[splittedDescription.length - 3]);
            _taskList.add(Task(
                id: event.id!,
                description: event.summary!,
                pomosDone: pomosDone,
                pomosTotal: pomosTotal));
          }
        }
      });
    });
  }

  _getTodoList() {
    if (_taskList.isNotEmpty) {
      List<Slidable> visualisedTasks = [];
      for (final task in _taskList) {
        visualisedTasks.add(task.getVisualisedTask());
      }
      return SizedBox(
          height: 60,
          width: 600,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: visualisedTasks,
          ));
    } else {
      return const Center(
          heightFactor: 20,
          child: Text(
            'No tasks created yet',
            style: TextStyle(fontSize: 18),
          ));
    }
  }
}
