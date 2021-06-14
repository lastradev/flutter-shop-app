import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  String? _authToken;
  String? _userId;

  set authToken(String value) {
    _authToken = value;
  }

  String get authToken {
    return _authToken.toString();
  }

  set userId(String value) {
    _userId = value;
  }

  String get userId {
    return userId.toString();
  }

  List<Product> _items = [];

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
    final url =
        Uri.parse('${dotenv.env['DB_URL']}products.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': _userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'] as String,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          '${dotenv.env['DB_URL']}products/$id.json?auth=$_authToken');

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
    }
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final _filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        '${dotenv.env['DB_URL']}products.json?auth=$_authToken&$_filterString');
    final favoriteUrl = Uri.parse(
        '${dotenv.env['DB_URL']}userFavorites/$_userId.json?auth=$_authToken');
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        return;
      }

      final favoriteResponse = await http.get(favoriteUrl);

      final data = json.decode(response.body) as Map<String, dynamic>;
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      data.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'] as String,
              description: prodData['description'] as String,
              price: prodData['price'] as double,
              imageUrl: prodData['imageUrl'] as String,
              isFavorite: (favoriteData == null
                  ? false
                  : favoriteData[prodId] ?? false) as bool,
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        Uri.parse('${dotenv.env['DB_URL']}products/$id.json?auth=$_authToken');

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    final existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }

  Future<void> addFavorite(String id) async {
    final url = Uri.parse(
        '${dotenv.env['DB_URL']}userFavorites/$_userId/$id.json?auth=$_authToken');

    final existingProduct = _items.firstWhere((prod) => prod.id == id);

    final response = await http.put(
      url,
      body: json.encode(existingProduct.isFavorite),
    );
    if (response.statusCode >= 400) {
      throw HttpException('Could not add favorite.');
    }
  }
}
