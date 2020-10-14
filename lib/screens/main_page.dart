import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String id = "mainpage";
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: SafeArea(
        child: MaterialButton(
          onPressed: () {},
          color: Colors.blue,
          minWidth: 200,
          child: Text('Hello'),
        ),
      ),
    );
  }
}
