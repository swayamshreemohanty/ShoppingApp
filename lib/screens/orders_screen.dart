// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _orderFuture;

  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    // print('building orderes');

    return Scaffold(
      backgroundColor: Colors.brown.shade50,

      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      // body: orderData.orders.isEmpty
      // ? Center(child: Text("No orders found!"))
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, dataSnapshot) {
          // print(dataSnapshot.data);
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                // print(orderData.orders.isEmpty);

                return orderData.orders.isEmpty
                    ? Center(
                        child: Text('No orders found!'),
                      )
                    : ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      );
              });
            }
          }
        },
      ),
    );
  }
}
