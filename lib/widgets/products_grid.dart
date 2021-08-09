// @dart=2.9

import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    //here productData is not the list of products, but to the objext based on this class.

    final products = productsData.items;
    //here the products is the list for the incoming list from products.dart

//info****
//this <Products>, is give info. about which type of data we actually want to listen.
//with this piece of information, we're telling the provider package that we want to establish a direct
//communication channel to the provided instance of the products class.
//****
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      // itemBuilder: (ctx, i) => ChangeNotifierProvider(
      //   create: (c) => products[i],
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //this is for 2 columns
        childAspectRatio: 3 / 2, //a bit taller than they are wide
        crossAxisSpacing: 10, //spacing between the columns
        mainAxisSpacing: 10, //space between the row
      ),
    );
  }
}
