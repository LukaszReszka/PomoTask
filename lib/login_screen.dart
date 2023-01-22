import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'calendar_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
      {super.key,
      required this.setLoadingState,
      required this.setLoggedInState,
      required this.setNotLoggedInState});

  final VoidCallback setLoadingState;
  final VoidCallback setLoggedInState;
  final VoidCallback setNotLoggedInState;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color(0xffea7066),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/tomato.png',
              height: 150,
            ),
            const SizedBox(
              height: 10,
            ),
            const DefaultTextStyle(
              style: TextStyle(color: Colors.white, fontSize: 20),
              child: Text('PomoTask - your time organizer :)'),
            ),
            const SizedBox(
              height: 10,
            ),
            SignInButton(
              Buttons.Google,
              onPressed: loginAction,
            )
          ]),
    );
  }

  Future<void> loginAction() async {
    widget.setLoadingState();
    final bool authSuccess = await GetIt.instance.get<CalendarClient>().login();
    if (authSuccess) {
      widget.setLoggedInState();
    } else {
      widget.setNotLoggedInState();
    }
  }
}
