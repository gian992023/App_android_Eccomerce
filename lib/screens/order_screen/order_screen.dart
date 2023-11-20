import 'package:conexion/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:conexion/models/order_model/order_model.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Mis ordenes",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestoreHelper.instance.getUserOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("No se encontraron ordenes"),
            );
          }

          if (snapshot.data!.isEmpty ||
              snapshot.data == null ||
              !snapshot.hasData) {
            return const Center(
              child: Text("No se encontraron ordenes"),
            );
          }
          return  Padding(padding: const EdgeInsets.only(bottom: 50),
            child:
            ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              OrderModel orderModel = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  collapsedShape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.red, width: 2.3)),
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.red, width: 2.3)),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        color: Colors.red.withOpacity(0.5),
                        child: Image.network(
                          orderModel.products[0].image,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderModel.products[0].name,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            orderModel.products.length > 1
                                ? SizedBox.fromSize()
                                : Column(
                                    children: [
                                      Text(
                                        "Cantidad: \$${orderModel.products[0].qty.toString()}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                            Text(
                              "Precio total: \$${orderModel.totalPrice.toString()}",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Estado de orden: ${orderModel.status}",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  children: orderModel.products.length > 1
                      ? [
                          const Text("Details"),
                          const Divider(color: Colors.red),
                          ...orderModel.products.map((singleProduct) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, top: 6.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.red.withOpacity(0.5),
                                        child: Image.network(
                                          singleProduct.image,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              singleProduct.name,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Cantidad: ${singleProduct.qty.toString()}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Precio: \$${singleProduct.price.toString()}",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.red),
                                ],
                              ),
                            );
                          }).toList()
                        ]
                      : [],
                ),
              );
            },
            ),
          );
        },
      ),
    );
  }
}
