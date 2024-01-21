// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conexion/constants/constants.dart';
import 'package:conexion/models/order_model/order_model.dart';
import 'package:conexion/models/product_model/product_model.dart';
import 'package:conexion/models/category_model/category_model.dart';
import 'package:conexion/models/user_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../../models/create_product_model/create_producto_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firebaseFirestore.collection("categories").get();
      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();
      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }
  Future<CategoryModel?> getCategory(String categoryId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> categorySnapshot =
      await FirebaseFirestore.instance.collection("categories").doc(categoryId).get();
      if (categorySnapshot.exists) {
        return CategoryModel.fromJson(categorySnapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      showMessage(e.toString());
      return null;
    }
  }



  Future<bool> createProductFirebase(CreateProductModel product,  BuildContext context, String categoryId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      showLoaderDialog(context);

      // Obtener la referencia de la categoría
      CategoryModel? category = await getCategory(categoryId);

      if (category != null) {
        // Obtener la referencia de la colección "categories" dentro de "userProducts" para el usuario actual
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("userProducts")
            .doc(userId)
            .collection("categories")
            .doc(categoryId);

        documentReference.set({
          "id": category.id,
          "image": category.image,
          "name": category.name,
        });
        CollectionReference productsCollection = documentReference.collection("Products");

        DocumentReference productDocRef = await productsCollection.add({

          "image": product.image,
          "name": product.name,
          "price": product.price,
          "description": product.description,
          "qty": product.qty,
        });


        print("Producto creado en la categoría ${category.name} para el usuario $userId");

        return true;
      } else {
        print("La categoría no existe: $categoryId");
        return false;
      }
    } catch (e) {
      print("Error creating product: $e");
      return false;
    }
  }

//Funcion obtencion de productos favoritos
  Future<List<ProductModel>> getBestProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firebaseFirestore.collectionGroup("products").get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }


//funcion Obtener informacion de categorias y sus productos
  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firebaseFirestore
          .collection("categories")
          .doc(id)
          .collection("products")
          .get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

//funcion obtener informacion del usuario empresarial
  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
    await _firebaseFirestore
        .collection("businessusers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return UserModel.fromJson(querySnapshot.data()!);
  }

// funcion subir orden de usuarios
  Future<bool> uploadOrderedProductFirebase(List<ProductModel> list,
      BuildContext context, String payment) async {
    try {
      showLoaderDialog(context);
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.qty!;
      }
      DocumentReference documentReference = _firebaseFirestore
          .collection("userOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc();
      DocumentReference admin = _firebaseFirestore.collection("orders").doc();

      admin.set({
        "products": list.map((e) => e.toJson()),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "orderId": admin.id,
      });

      documentReference.set({
        "products": list.map((e) => e.toJson()),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "orderId": documentReference.id,
      });
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Orden exitosa");
      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

  //funcion obtener orden usuario
  Future<List<OrderModel>> getUserOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firebaseFirestore
          .collection("userOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .get();
      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fromJson(element.data()))
          .toList();
      return orderList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

//funcion actualizar token de usuario empresarial
  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection("businessusers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "notificationToken": token,
      });
    }
  }
}
