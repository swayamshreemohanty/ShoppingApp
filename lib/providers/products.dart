// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    var url =
        'https://flutter-shop-app-a0458-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      print("This is response body");
      print(json.decode(response.body));

      //here we using 'dynamic', because Dart doesn't understand this nested map, coming from the firebase.
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // print("This is extractedData");
      // print(extractedData);
      if (extractedData == null) {
        _items.clear();
        return;
      }
      url =
          'https://flutter-shop-app-a0458-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      print("This is favorite response body");
      print(json.decode(favoriteResponse.body));
      final List<Product> loadedProducts = []; //empty temporary list
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            //here, if the favorite status is null, then the user never set the favorite status and it is set false by default,
            //if it is not null then and the favoriteData is avaible then it's check the product Id and assign the status to it.
            //if the favoriteData[prodId] is also null/ !true then it is fall back to the status after the ??, and i.e false.
          ),
        );
      });
      _items = loadedProducts; // To show the new order on the top
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    //Ny using 'async', all of the below code which are come under the 'Future' automatically wrapped in to a Future.
    //using this 'async' here, the function or the method on which we use it always returns a future and that future might
    //then not ield anything in the end but it always returns  a future because this now is all wrapped into a future.
    final url =
        'https://flutter-shop-app-a0458-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';

    //Here we return this http.post(), because here we return the result of calling post and
    //then calling .then() and the result of calling .then() is another future and that's the future we return here.
    //************************************//

    //Here 'await' keyword tells Dart that we want to wait for this operation to finish before we move on
    //to the next line in our Dart code. Internally it is still run the other code and wait for the response
    //to execute the '.then()'.

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      final newProduct = Product(
        id: (json.decode(
            response.body)['name']), //here the ['name'] is a return by server
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      // print(json.decode(response.body));

      // print("Product id from firebase is: " + newProduct.id);
      _items.add(newProduct);
      // _items.insert(0, newProduct);  //This is a alternative method to add the list at the begining.
      notifyListeners();
    } catch (error) {
      print(error);
      print("Catch and threw the error");
      throw error;
    }

    // JSON= JavaScript Object Notation
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shop-app-a0458-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
              'isFavorite': newProduct.isFavorite,
            }));
        //a patch request will tell Firebase to merge the data which is incoming with the existing data at that.
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }
//this is fucntion is used to update the existing products,
//triggered from the modify products from the drawer.

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shop-app-a0458-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
//******************
    notifyListeners();
//**********************
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete porduct.');
    }
    existingProduct = null;
  }
}
