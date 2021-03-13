import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      home: Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
        ),
        body: Center(
          child: Container(
            child: Text('Let\'s build a shop!'),
          ),
        ),
      ),
    );
  }
}
