// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    //Because of this productData= Provider... , we have rebuilt the entire page, (because of the listener) when the product change
    //If you don't turnoff this, this will cause a infinite loop, because below we are calling the _refreshproduct() by the FutureBuilder
    //which go ahed and fetching products and update the products in this screen. By this our build method will retrigger and also by this
    //our future builder also will retrigger. Soo this process is goin on to an infinity loop.
    //Yes, if we add listen:false, then it should work.

    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            //'icon' is the argument, 'Icon()' is the widget, 'Icons.add' is the sign.
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        //Here FutureBuilder is used to load this screen the at time of 1st load to show the items
        //filter by userId.
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                color: Colors.blue,
                child: Consumer<Products>(
                  builder: (ctx, productData, _) => productData.items.isEmpty
                      ? Center(
                          child: Text("No data available!"),
                        )
                      : Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (ctx, i) => Column(children: [
                              UserProductItem(
                                productData.items[i].id,
                                productData.items[i].title,
                                productData.items[i].imageUrl,
                              ),
                              Divider(),
                            ]),
                          ),
                        ),
                ),
              ),
      ),
    );
  }
}
