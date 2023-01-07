import 'package:flutter/material.dart';
import 'package:pomo_task/time_settings_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  int _counter = 0;

  @override
  void initState() {
    _setLoadingState();
    //TODO reszta - trzeba też zmienić w Calendar
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
        drawer: TimeSettingsDrawer());
  }

  void _setLoadingState() {
    setState(() {
      _isLoading = true;
    });
  }

  void _setLoggedInState() {
    setState(() {
      _isLoading = false;
      _isLoggedIn = true;
    });
  }

  void _setNotLoggedInState() {
    setState(() {
      _isLoading = false;
      _isLoggedIn = false;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}
