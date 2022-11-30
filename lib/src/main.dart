import 'package:flutter/material.dart';
import 'package:wheelgo/src/widgets/MainMap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Wheelgo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainMap()
    );
  }
}
