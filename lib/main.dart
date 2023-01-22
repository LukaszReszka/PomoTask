import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pomo_task/calendar_client.dart';
import 'package:pomo_task/loading_screen.dart';
import 'package:pomo_task/login_screen.dart';
import 'main_screen.dart';

Future<void> main()  async {
  GetIt.instance.registerSingleton<CalendarClient>(CalendarClient());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool _isLoading = false;
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PomoTask App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SafeArea(
        child: Builder (
          builder: (context) {
            if(_isLoading) {
              return const LoadingScreen();
            } else if(_isLoggedIn) {
              return MainScreen(setNotLoggedInState: setNotLoggedInState);
            } else {
              return LoginScreen(
                  setLoadingState: setLoadingState,
                  setLoggedInState: setLoggedInState,
                  setNotLoggedInState: setNotLoggedInState
              );
            }
          },
        ),
      ),
    );
  }
  // const MainScreen(title: 'PomoTask')
  @override
  void initState() {
    initAuth();
    super.initState();
  }

  initAuth() async {
    setLoadingState();
    final bool isAuthenticated = await GetIt.instance.get<CalendarClient>().initAuth();
    if(isAuthenticated) {
      setLoggedInState();
    } else {
      setNotLoggedInState();
    }
  }

  setLoadingState() {
    setState(() {
      _isLoading = true;
    });
  }

  setLoggedInState() {
    setState(() {
      _isLoading = false;
      _isLoggedIn = true;
    });
  }

  setNotLoggedInState() {
    setState(() {
      _isLoading = false;
      _isLoggedIn = false;
    });
  }
}
