import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pomo_task/time_settings_drawer.dart';

import 'calendar_client.dart';

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
          actions: const [
            IconButton(
              icon: Icon(Icons.calendar_month),
              onPressed: null,
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void logout() async {
    await GetIt.instance.get<CalendarClient>().logout();
    widget.setNotLoggedInState();
  }
}
