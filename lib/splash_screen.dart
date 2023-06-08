import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wisdom_jotter/functions.dart';
import 'package:wisdom_jotter/main_app.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer(Duration(seconds: 3), () => moveToPage(MainApp(), context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Spacer(),
            SelectableText(
              'Wisdom Jotter App',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Spacer(),
            SelectableText(
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
