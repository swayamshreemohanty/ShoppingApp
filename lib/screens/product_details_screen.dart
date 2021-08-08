//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-details";

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(context).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.id),
      ),
    );
  }
}
