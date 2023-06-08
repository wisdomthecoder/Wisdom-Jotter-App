import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  runApp(MyApp());
}

GetStorage box = GetStorage();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;
  @override
  void initState() {
    initTheme();

    super.initState();
  }

  Future initTheme() async {
    if (box.read('isDark') != null) {
      isDark = box.read('isDark');
    } else {
      box.writeIfNull('isDark', false);
      box.save();
    }
  }

  // int seconds = 4;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wisdom Jotter',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
        ),
        home: Splash());
  }
}
