// --no-sound-null-safety
// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => null,
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => null,
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.amber,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapShot) =>
                          authResultSnapShot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductOverviewScreen.routeName: (ctx) =>
                    ProductOverviewScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              }),
        ));
  }
}
