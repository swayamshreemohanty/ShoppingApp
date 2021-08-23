//@dart=2.9
import 'package:flutter/material.dart';

import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = "/product_overview";
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    //**This mehtod is use to refresh the screen for fetched product from the server automatically**//

    //***tip***/
    //here we can't using 'await' and 'async',because for didChangeDependencies or for initState
    //because these are not methods which return futures and since we override the built-in methods,
    //we shouldn't change what they return. So using async here would change what they return because
    //an async method always returns a future.
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   // Provider.of<Products>(context).fetchAndSetProducts(); // this is won't work. If you add listen:false, then it will work
  //   Future.delayed(Duration.zero).then((value) {
  //     //here Duration is used to set delay
  //     Provider.of<Products>(context).fetchAndSetProducts();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        title: Text('RedTape'),

        //PopupMenuButton(), used to open a kind of a drop over menu as opens up as an Overlay
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, bottomChild) => Badge(
              child: bottomChild,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
