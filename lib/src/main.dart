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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          primarySwatch: Colors.blue,
          useMaterial3: true,
          visualDensity: VisualDensity.standard
        ),
        home: const MainMap()
    );
  }
}
