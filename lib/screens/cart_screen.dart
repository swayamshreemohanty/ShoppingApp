// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart'; //or 'as widget';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text('No items in your cart!'),
            )
          : Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total', style: TextStyle(fontSize: 20)),
                        // SizedBox(width: 10),
                        Spacer(),
                        Chip(
                          label: Text(
                            '\₹${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  // ignore: deprecated_member_use
                                  .title
                                  .color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ), //String interpolation
                        // ignore: deprecated_member_use
                        OrderButton(cart: cart)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                    child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title,
                  ),
                ))
              ],
            ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
              // await showDialog(
              //   context: context,
              //   builder: (ctx) => AlertDialog(
              //     title: Text('Order placed successful'),
              //     content: Text('Thanks for ordering'),
              //     actions: [
              //       FlatButton(
              //         onPressed: () {
              //           Navigator.of(context).pop();
              //         },
              //         child: Text('Okay'),
              //       ),
              //     ],
              //   ),
              // );
              Navigator.of(context)
                  .popAndPushNamed(ProductOverviewScreen.routeName);
              ScaffoldMessenger.of(context)
                  .hideCurrentSnackBar(); //it is used to show the current snackbar message, by overwriting the previous snackbar message.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order placed successful!'),
                  duration: Duration(seconds: 3),
                ),
              );
            },

      child: _isLoading
          ? CircularProgressIndicator(
              color: Colors.blue,
            )
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Colors.black),
            ),

      // textColor: Theme.of(context).accentColor,
    );
  }
}
