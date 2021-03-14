import 'package:flutter/material.dart';
import 'screens/products_overview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.indigoAccent,
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
    );
  }
}
