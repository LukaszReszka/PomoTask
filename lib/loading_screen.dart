import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

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
          const CircularProgressIndicator(
            backgroundColor: Color(0xffea7066),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
