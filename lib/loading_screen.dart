import 'package:flutter/material.dart';
import 'package:pomo_task/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: minorColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            pathToLogo,
            height: 150,
          ),
          const SizedBox(
            height: 10,
          ),
          const CircularProgressIndicator(
            backgroundColor: minorColor,
            color: backgroundColor,
          )
        ],
      ),
    );
  }
}
