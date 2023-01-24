import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pomo_task/time_settings_drawer.dart';
import 'package:pomo_task/todo_list.dart';

import 'calendar_client.dart';
import 'constants.dart';
import 'date_picker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.setNotLoggedInState});

  final VoidCallback setNotLoggedInState;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _counter = 0;

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
              DateChooser(replaceTaskList: nothing), //TODO metoda GroupLists
              const Divider(
                color: minorColor,
                thickness: 3,
              ),
              const TodoList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        drawer: TimeSettingsDrawer(
          logoutAction: logout,
        ));
  }

  Future<void> _incrementCounter() async {
    await GetIt.instance
        .get<CalendarClient>()
        .addEvent('Test', '2023-01-23 23:15', '2023-01-23 23:30', 1, 2);
    setState(() {
      _counter++;
    });
  }

  void logout() async {
    await GetIt.instance.get<CalendarClient>().logout();
    widget.setNotLoggedInState();
  }

  nothing() {
    return;
  }
}
