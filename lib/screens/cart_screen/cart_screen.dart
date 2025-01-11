import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conexion/constants/constants.dart';
import 'package:conexion/constants/routes.dart';
import 'package:conexion/screens/cart_item_checkout/cart_item_checkout.dart';
import 'package:conexion/screens/cart_screen/widgets/single_cart_item.dart';
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

  // Función para buscar el ownerId del producto
  Future<String?> findDocumentId(String productId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collectionGroup("userProducts").get();

    for (var doc in querySnapshot.docs) {
      QuerySnapshot categoriesQuerySnapshot = await FirebaseFirestore.instance
          .collection("userProducts")
          .doc(doc.id)
          .collection("categories")
          .get();
      for (var categoryDoc in categoriesQuerySnapshot.docs) {
        QuerySnapshot productsQuerySnapshot = await FirebaseFirestore.instance
            .collection("userProducts")
            .doc(doc.id)
            .collection("categories")
            .doc(categoryDoc.id)
            .collection("products")
            .get();
        for (var productDoc in productsQuerySnapshot.docs) {
          var data = productDoc.data() as Map<String, dynamic>?;
          if (data != null && data['id'] == productId) {
            return doc.id; // Retorna el ownerId (document id) del producto
          }
        }
      }
    }
    return null;
  }

  // Función para buscar el categoryId del producto
  Future<String?> findCategoryId(String productId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collectionGroup("userProducts").get();

    for (var doc in querySnapshot.docs) {
      QuerySnapshot categoriesQuerySnapshot = await FirebaseFirestore.instance
          .collection("userProducts")
          .doc(doc.id)
          .collection("categories")
          .get();
      for (var categoryDoc in categoriesQuerySnapshot.docs) {
        QuerySnapshot productsQuerySnapshot = await FirebaseFirestore.instance
            .collection("userProducts")
            .doc(doc.id)
            .collection("categories")
            .doc(categoryDoc.id)
            .collection("products")
            .get();
        for (var productDoc in productsQuerySnapshot.docs) {
          var data = productDoc.data() as Map<String, dynamic>?;
          if (data != null && data['id'] == productId) {
            return categoryDoc.id; // Retorna el categoryId
          }
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${appProvider.totalPrice().toString()}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                title: "Continuar",
                onPressed: () async {
                  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

                  // Verifica si el carrito no está vacío
                  if (appProvider.getCartProductList.isEmpty) {
                    showMessage("El carrito está vacío");
                    return;
                  }

                  // Recorre cada producto en el carrito
                  for (var singleProduct in appProvider.getCartProductList) {
                    int qtyToBuy = singleProduct.qty!; // Cantidad que el usuario desea comprar
                    String? ownerId = await findDocumentId(singleProduct.id);
                    String? categoryId = await findCategoryId(singleProduct.id);

                    if (ownerId != null && categoryId != null) {
                      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
                          .collection("userProducts")
                          .doc(ownerId)
                          .collection("categories")
                          .doc(categoryId)
                          .collection("products")
                          .doc(singleProduct.id)
                          .get();

                      int availableQty = (productSnapshot.data() as Map<String, dynamic>?)?['qty'] ?? 0;


                      // Verifica si hay suficiente inventario
                      if (availableQty >= qtyToBuy) {
                        int newQty = availableQty - qtyToBuy; // Resta la cantidad que el usuario seleccionó, no la cantidad total

                        // Actualiza el inventario en la base de datos
                        await FirebaseFirestore.instance
                            .collection("userProducts")
                            .doc(ownerId)
                            .collection("categories")
                            .doc(categoryId)
                            .collection("products")
                            .doc(singleProduct.id)
                            .update({'qty': newQty});
                      } else {
                        showMessage("No hay suficiente inventario para el producto: ${singleProduct.name}");
                        return;
                      }
                    } else {
                      // Manejar el caso en que no se encuentran los IDs
                      showMessage("No se encontró el dueño o la categoría del producto: ${singleProduct.name}");
                      return;
                    }
                  }

                  // Registra la compra en las colecciones "orders" y "userorders"
                  appProvider.clearBuyProduct();
                  appProvider.addBuyProductCartList();
                  appProvider.clearCart();

                  // Redirigir a la página de pago
                  Routes.instance.push(
                    widget: const CartItemCheckout(),
                    context: context,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Vista de carrito",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: appProvider.getCartProductList.isEmpty
          ? const Center(child: Text("Carrito vacío"))
          : ListView.builder(
        itemCount: appProvider.getCartProductList.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (ctx, index) {
          return SingleCartItem(
            singleProduct: appProvider.getCartProductList[index],
          );
        },
      ),
    );
  }
}
