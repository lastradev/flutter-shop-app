import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    // id: 'p1',
    // title: 'Red Shirt',
    // description: 'A red shirt - it is pretty red!',
    // price: 29.99,
    // imageUrl: 'https://i.imgur.com/ylvvncy.jpg',
    // ),
    // Product(
    // id: 'p2',
    // title: 'Trousers',
    // description: 'A nice pair of trousers.',
    // price: 59.99,
    // imageUrl:
    // 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    // id: 'p3',
    // title: 'Yellow Scarf',
    // description: 'Warm and cozy - exactly what you need for the winter.',
    // price: 19.99,
    // imageUrl:
    // 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    // id: 'p4',
    // title: 'A Pan',
    // description: 'Prepare any meal you want.',
    // price: 49.99,
    // imageUrl:
    // 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'flutter-course-ab219-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
        'flutter-course-ab219-default-rtdb.firebaseio.com',
        '/products/$id.json',
      );
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('Product id not found in products.dart updateProduct method');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'flutter-course-ab219-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: prodData['isFavorite'],
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
