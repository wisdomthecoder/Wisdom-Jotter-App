import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Spacer(),
            Text(
              'Wisdom Jotter App',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Spacer(),
            Text(
              'Powered By Wisdom Dauda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
