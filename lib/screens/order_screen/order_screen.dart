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
        future: FirebaseFirestoreHelper.instance.getUserOrder(context),
        builder: (context, snapshot) {
          if (snapshot.data!.isEmpty || snapshot.data == null) {
            return Center(
              child: Text("No se encontraron ordenes"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              OrderModel orderModel= snapshot.data![index];
              return ExpansionTile(
                title: Text(
                  orderModel.payment,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      orderModel.status,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            },
          );
        },
      ),
    );
  }
}
