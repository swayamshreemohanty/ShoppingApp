//@dart=2.9
// import 'dart:ui';

import 'dart:ui';

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
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        //slivers are the scrollable areas on the screen.
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.indigo.shade400),
            // leading: BackButton(color: Colors.indigo.shade200,),
            expandedHeight: 300, //this is the height without the appBar.
            pinned: true,

            //pinned:true means, the appBar will always be visible when we scroll,it will not scroll out of view
            //but instead it will simply change to an appBar and then stick at the top.
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                loadedProduct.title,
                style: TextStyle(color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: loadedProduct.id,
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        stops: [0.3, 0.4],
                        colors: <Color>[
                          Color(0x60000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // const SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 30,
          //     child: Center(
          //       child: Text("Data"),
          //     ),
          //   ),
          // ),
          //delegate tells the slivers that how to render the content of the list.
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '\₹${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
