import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pomo_task/calendar_client.dart';
import 'main_page.dart';

Future<void> main() async {
  GetIt.instance.registerSingleton<CalendarClient>(CalendarClient());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PomoTask App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MainPage(title: 'PomoTask'),
    );
  }
}
