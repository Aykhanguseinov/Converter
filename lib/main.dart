import 'package:flutter/material.dart';

import 'home.dart'; 
import 'weight.dart';
import 'length.dart';
import 'money.dart';
import 'temperature.dart';
import 'square.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => Home(),
        '/weight': (context) => Weight(),
        '/length': (context) => Length(),
        '/money': (context) => Money(),
        '/temp': (context) => Temperature(),
        '/square': (context) => Square(),
      },
    );
  }
}