// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    //Ny using 'async', all of the below code which are come under the 'Future' automatically wrapped in to a Future.
    //using this 'async' here, the function or the method on which we use it always returns a future and that future might
    //then not ield anything in the end but it always returns  a future because this now is all wrapped into a future.
    const url =
        'https://flutter-shop-app-a0458-default-rtdb.asia-southeast1.firebasedatabase.app/products';
    //**1st method**//
    // return http
    //     .post(
    //Here we return this http.post(), because here we return the result of calling post and
    //then calling .then() and the result of calling .then() is another future and that's the future we return here.
    //************************************//

    //** 2nd method **//
    // await http
    //     .post(
    //   url,
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
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProduct = Product(
        id: (json.decode(response.body)['name']),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      print("Product id from firebase is: " + newProduct.id);
      _items.add(newProduct);
      // _items.insert(0, newProduct);  //This is a alternative method to add the list at the begining.
      notifyListeners();
    } catch (error) {
      print(error);
      print("Catch and threw the error");
      throw error;
    }

    //** 1st .then() Method**/
    // .then((response) {
    // print(json.decode(response.body)); //this is for print the response

    //***2nd invisible .then() method ***//
    //here, we wrap the upper part in a final response with the 'await', by doing this here a invisible
    //.then() block will run to excecute the below codes after the response will recieved in the upper block
    // final newProduct = Product(
    //   id: (json.decode(response.body)['name']),
    //   title: product.title,
    //   description: product.description,
    //   price: product.price,
    //   imageUrl: product.imageUrl,
    // );
    // print("Product id from firebase is: " + newProduct.id);
    // _items.add(newProduct);
    // // _items.insert(0, newProduct);  //This is a alternative method to add the list at the begining.
    // notifyListeners();

    //***1st .then() ***//not neccessary for invisible .then() method//
    // }).catchError((error) {
    //   print(error);
    //   print("Catch and threw the error");
    //   throw error;

    // JSON= JavaScript Object Notation
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }
//this is fucntion is used to update the existing products,
//triggered from the modify products from the drawer.

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
