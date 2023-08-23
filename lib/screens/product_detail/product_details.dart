import 'package:conexion/constants/constants.dart';
import 'package:conexion/constants/routes.dart';
import 'package:conexion/models/product_model/product_model.dart';
import 'package:conexion/provider/app_provider.dart';
import 'package:conexion/screens/cart_screen/cart_screen.dart';
import 'package:conexion/screens/favourite_screen/favourite_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;

  const ProductDetails({super.key, required this.singleProduct});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Routes.instance
                  .push(widget: const CartScreen(), context: context);
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.singleProduct.image,
                height: 400,
                width: 400,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.singleProduct.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.singleProduct.isFavourite =
                            !widget.singleProduct.isFavourite;
                      });
                      if (widget.singleProduct.isFavourite) {
                        appProvider.addFavouriteProduct(widget.singleProduct);
                      }else{
                        appProvider.removeFavouriteProduct(widget.singleProduct);
                      }
                    },
                    icon: Icon(appProvider.getFavouriteProductList.contains(widget.singleProduct)
                        ? Icons.favorite
                        : Icons.favorite_border_outlined),
                  )
                ],
              ),
              Text(widget.singleProduct.description),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  CupertinoButton(
                    onPressed: () {
                      if (qty >= 1) {
                        setState(() {
                          qty--;
                        });
                      }
                    },
                    padding: EdgeInsets.zero,
                    child: CircleAvatar(
                      child: Icon(Icons.remove),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    qty.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        qty++;
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: CircleAvatar(
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              //const Spacer(),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      ProductModel productModel =
                          widget.singleProduct.copyWith(qty: qty);
                      appProvider.addCartProduct(productModel);
                      showMessage("Agregado al carrito");
                    },
                    child: const Text(
                      "Agregar al carrito",
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  SizedBox(
                    height: 38,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        Routes.instance
                            .push(widget: const FavouriteScreen(), context: context);
                      },
                      child: const Text("Comprar"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
