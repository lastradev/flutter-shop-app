import 'package:flutter/material.dart';
import 'providers/products.dart';
import 'package:provider/provider.dart';

import 'screens/product_detail_screen.dart';
import 'screens/products_overview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            accentColor: Colors.indigoAccent,
            fontFamily: 'Lato',
          ),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen()
          }),
    );
  }
}
