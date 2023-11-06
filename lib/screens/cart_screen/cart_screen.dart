import 'package:conexion/constants/constants.dart';
import 'package:conexion/constants/routes.dart';
import 'package:conexion/screens/cart_item_checkout/cart_item_checkout.dart';
import 'package:conexion/screens/cart_screen/widgets/single_cart_item.dart';
import 'package:conexion/screens/check_out/check_out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';
import '../../widgets/primary_button/primary_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${appProvider.totalPrice().toString()}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              PrimaryButton(
                title: "Hacer pago",
                onPressed: () {
                  appProvider.clearBuyProduct();
                  appProvider.addBuyProductCartList();
                  appProvider.clearCart();
                  if (appProvider.getBuyProductList.isEmpty) {
                    showMessage("Carta esta vacia");
                  } else {
                    Routes.instance.push(
                        widget: const CartItemCheckout(), context: context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        //backgroundColor: Colors.cyan,
        centerTitle: true,
        title: const Text(
          "Vista de carta",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: appProvider.getCartProductList.isEmpty
          ? const Center(
              child: Text("Vacio"),
            )
          : ListView.builder(
              itemCount: appProvider.getCartProductList.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (ctx, index) {
                return SingleCartItem(
                  singleProduct: appProvider.getCartProductList[index],
                );
              }),
    );
  }
}
