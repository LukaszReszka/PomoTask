import 'dart:developer';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:pomo_task/task.dart';
import 'package:pomo_task/time_settings_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<Slidable> _visualisedTasks = [];
  DateTime chosenDate = DateTime.now();

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
          actions: [
            IconButton(
                onPressed: () => _displayPomodoroTimer(context),
                icon: const Icon(
                  Icons.rocket_launch,
                ))
          ],
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
              const SizedBox(height: 10),
              _getTodoList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayCreationDialog(context),
          tooltip: 'Increment',
          child: const Icon(Icons.add_task),
        ),
        drawer: TimeSettingsDrawer(
          logoutAction: logout,
        ));
  }

  _addEvent(String taskName, int pomosTotal, String date) async {
    Event event = await GetIt.instance
        .get<CalendarClient>()
        .addEvent(taskName, '$date 09:00', '$date 09:30', 0, pomosTotal);
    setState(() {
      _taskList.add(Task(
          id: event.id!,
          description: taskName,
          pomosDone: 0,
          pomosTotal: pomosTotal,
          deleteEvent: _deleteTask,
          editEvent: _displayEditDialog));
    });
  }

  _displayCreationDialog(BuildContext context) async {
    var nameController = TextEditingController();
    var pomosController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to TODO list'),
            content: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                    child: Column(children: [
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z]+[a-zA-Z ]*$')),
                      LengthLimitingTextInputFormatter(20)
                    ],
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter task name'),
                  ),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[1-9]+[0-9]*$')),
                      LengthLimitingTextInputFormatter(2)
                    ],
                    controller: pomosController,
                    decoration:
                        const InputDecoration(hintText: 'Enter pomos number'),
                  )
                ]))),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  _addEvent(
                      nameController.text,
                      int.parse(pomosController.text),
                      DateFormat('yyyy-MM-dd').format(chosenDate));
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _displayPomodoroTimer(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    var controller = CountDownController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pomodoro Timer'),
            content: SizedBox(
                height: 350,
                width: 400,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircularCountDownTimer(
                        width: 300,
                        height: 300,
                        duration: prefs.getInt('Pomodoro')! * 60,
                        fillColor: majorColor,
                        ringColor: minorColor,
                        isReverse: true,
                        strokeWidth: 7,
                        controller: controller,
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ])),
            actions: <Widget>[
              TextButton(
                child: const Text('Resume'),
                onPressed: () {
                  controller.resume();
                },
              ),
              TextButton(
                child: const Text('Pause'),
                onPressed: () {
                  controller.pause();
                },
              ),
              TextButton(
                child: const Text('Stop'),
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
    chosenDate = newDate;
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
                pomosTotal: pomosTotal,
                deleteEvent: _deleteTask,
                editEvent: _displayEditDialog));
          }
        }
      });
    });
  }

  _getTodoList() {
    if (_taskList.isNotEmpty) {
      _visualisedTasks = [];
      for (final task in _taskList) {
        _visualisedTasks.add(task.getVisualisedTask());
      }

      return SizedBox(
          height: 60,
          width: 600,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: _visualisedTasks,
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

  _deleteTask(String taskId) {
    GetIt.instance.get<CalendarClient>().deleteEvent(taskId);
    setState(() {
      _taskList.removeAt(0);
    });
  }

  _editTask(
      String taskId, String description, int pomosDone, int pomosTotal) async {
    if (pomosDone < pomosTotal) {
      Event? newEvent = await GetIt.instance
          .get<CalendarClient>()
          .editEvent(taskId, description, pomosDone, pomosTotal);
      setState(() {
        _taskList[0] = Task(
            id: newEvent!.id!,
            description: newEvent.summary!,
            pomosDone: pomosDone,
            pomosTotal: pomosTotal,
            deleteEvent: _deleteTask,
            editEvent: _displayEditDialog);
      });
    } else {
      _deleteTask(taskId);
    }
  }

  _displayEditDialog(BuildContext context, String taskId, String description,
      int pomosDone, int pomosTotal) async {
    var nameController = TextEditingController(text: description);
    var pomosController = TextEditingController(text: pomosTotal.toString());
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit task from TODO list'),
            content: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                    child: Column(children: [
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z]+[a-zA-Z ]*$')),
                      LengthLimitingTextInputFormatter(20)
                    ],
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter task name'),
                  ),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[1-9]+[0-9]*$')),
                      LengthLimitingTextInputFormatter(2)
                    ],
                    controller: pomosController,
                    decoration:
                        const InputDecoration(hintText: 'Enter pomos number'),
                  )
                ]))),
            actions: <Widget>[
              TextButton(
                child: const Text('Edit'),
                onPressed: () {
                  _editTask(taskId, nameController.text, pomosDone,
                      int.parse(pomosController.text));
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
