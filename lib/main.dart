import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'myhome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          return const MyHomePage();
        },
      ),
    );
  }
}
