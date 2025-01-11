import 'package:conexion/constants/routes.dart';
import 'package:conexion/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:conexion/models/product_model/product_model.dart';
import 'package:conexion/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../provider/app_provider.dart';
import '../../widgets/primary_button/primary_button.dart';

class Checkout extends StatefulWidget {
  final ProductModel singleProduct;

  const Checkout({super.key, required this.singleProduct});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int groupValue = 1;
  int qty = 1; // Default quantity
  String? ownerId;
  String? categoryId;
  String? businessName;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String? customerName;


  @override
  void initState() {
    super.initState();
    _fetchOwnerId();
    _fetchCategoryId();
    _fetchCustomerName();
  }
// Obtener el nombre del cliente
  Future<void> _fetchCustomerName() async {
    // Intentar obtener el nombre desde FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      setState(() {
        customerName = user.displayName!;
      });
    } else {
      // Si no está disponible, intentar obtenerlo desde Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null && userDoc.data()!['name'] != null) {
        setState(() {
          customerName = userDoc.data()!['name'];
        });
      } else {
        setState(() {
          customerName = "Cliente Desconocido";
        });
      }
    }
  }
  Future<void> _fetchCategoryId() async {
    String? foundCategoryId = await findCategoryId(widget.singleProduct.id);
    if (foundCategoryId != null) {
      setState(() {
        categoryId = foundCategoryId;
      });
    }
  }

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
            return categoryDoc.id;
          }
        }
      }
    }

    return null;
  }

  Future<void> _fetchOwnerId() async {
    String? foundOwnerId = await findDocumentId(widget.singleProduct.id);
    if (foundOwnerId != null) {
      setState(() {
        ownerId = foundOwnerId;
        _fetchBusinessName(foundOwnerId);
      });
    }
  }

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
            return doc.id;
          }
        }
      }
    }

    return null;
  }

  Future<String?> findBusinessUser(String ownerId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("businessusers")
        .doc(ownerId)
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['name'];
    }

    return null;
  }

  Future<void> _fetchBusinessName(String ownerId) async {
    String? name = await findBusinessUser(ownerId);
    if (name != null) {
      setState(() {
        businessName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Pagos",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(
              height: 36,
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).primaryColor, width: 3),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  const Icon(Icons.money),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    "Contraentrega",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).primaryColor, width: 3),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  Icon(Icons.money),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Reclamar en local",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            PrimaryButton(
              title: "Pagar",
              onPressed: () async {

                appProvider.clearBuyProduct();
                String uniqueProductId = FirebaseFirestore.instance.collection('dummy').doc().id;
                appProvider.addBuyProduct(widget.singleProduct);

                bool value = await FirebaseFirestoreHelper.instance.uploadOrderedProductFirebase(
                    appProvider.getBuyProductList,
                    context,
                    groupValue == 1 ? "Contraentrega" : "Pago",
                    uniqueProductId
                );

                // Código  para registrar la venta de producto
                if (value) {
                  if (ownerId != null) {
                    int availableQty = widget.singleProduct.qty!;
                    if (availableQty >= qty) {
                      // Crear el documento en "ventas" con el ID del ownerId
                      DocumentReference ventaDocRef = FirebaseFirestore.instance
                          .collection("ventas")
                          .doc(ownerId)
                          .collection("clientes")
                          .doc(userId)
                          .collection("productos")
                          .doc();

                      // Subir la información adicional requerida en la estructura
                      await FirebaseFirestore.instance
                          .collection("ventas")
                          .doc(ownerId)
                          .set({
                        "id": ownerId, // Campo agregado con el id del ownerId
                      });

                      await FirebaseFirestore.instance
                          .collection("ventas")
                          .doc(ownerId)
                          .collection("clientes")
                          .doc(userId)
                          .set({
                        "id": userId, // Campo agregado con el id del userId
                        "name": customerName ?? "Nombre desconocido", // Campo agregado con el nombre del usuario
                      });

                      // Registrar la información del producto bajo la estructura deseada
                      await ventaDocRef.set({
                        "idventa": uniqueProductId,
                        "product": widget.singleProduct.toJson(),
                        "status": "pendiente",
                      });

                      Future.delayed(const Duration(seconds: 2), () {
                        Routes.instance.push(
                            widget: const CustomBottomBar(initialIndex: 2),
                            context: context
                        );
                      });

                    } else {
                      showMessage("Error al encontrar el propietario del producto");
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
