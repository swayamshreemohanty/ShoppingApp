// @dart=2.9

import 'package:flutter/material.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Menu"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //   CustomRoute(
              //     builder: (ctx) => OrderScreen(),
              //   ),
              // );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are you sure!'),
                  content: Text('You are about to logout!'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); //to close the drawer
                      },
                      child: Text('No'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); //to close the drawer
                        Navigator.of(context).pushReplacementNamed('/');
                        Provider.of<Auth>(context, listen: false).logout();
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
