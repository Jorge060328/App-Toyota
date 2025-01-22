import 'package:flutter/material.dart';
import 'package:toyota_production_system/screens/main_menu.dart';
import 'package:toyota_production_system/screens/new_map_screen.dart';
import 'package:toyota_production_system/screens/activity_screen.dart';
import 'package:toyota_production_system/screens/process_map_screen.dart';
import 'package:toyota_production_system/screens/edit_map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainMenu(),
        '/newMap': (context) => NewMapScreen(),
        '/activity': (context) => ActivityScreen(),
        '/processMap': (context) => ProcessMapScreen(),
        '/editMap': (context) => EditMapScreen(),
      },
    );
  }
}
