// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        // if we do not add the Container(), here in the Row(), takes as much space as it can get,
        //and trailling the place where we insert this into the ListTile doesn't restrict that size,
        //so we cause the error.
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleteing failed')));
                }
//here we are not directly using the Scaffold.of(context), because here everything comes under the 'Future' and in this 'Future'
//'async' is used and therefore everything in these is wrapped into a Future and for this reason 'context' can't actually
//be resolved anymore due to Flutter internal mechanism.
//If we use Scaffold.of(context) in the 'Future', when the code touch to it, it's already updating the widget tree
//at this point of time, it's not sure whether a context still referes to the same context it did before.
//So, if we add the Scaffold.of(context) at the build method starting point and store into a variable, then every thing wil work fine.
//because if we using a variable in the 'Future', here we are just using a variable instead of refecting access.
              },
            ),
          ],
        ),
      ),
    );
  }
}
