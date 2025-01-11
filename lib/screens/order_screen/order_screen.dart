import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conexion/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:conexion/models/order_model/order_model.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  Future<String?> findOwnerId(String productId) async {
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
            // Retornar el ID del dueño del producto
            return doc.id;
          }
        }
      }
    }
    return null;
  }

  void _showSurveyDialog(
      BuildContext context, String ownerId, OrderModel orderModel) {
    int qualityRating = 0;
    int punctualityRating = 0;
    int accuracyRating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Califique su experiencia'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRatingQuestion(
                    '¿Cómo calificarías la calidad del producto recibido?',
                        (rating) {
                      setState(() {
                        qualityRating = rating;
                      });
                    },
                    qualityRating,
                  ),
                  _buildRatingQuestion(
                    '¿Qué tan conforme estás con la puntualidad en la entrega?',
                        (rating) {
                      setState(() {
                        punctualityRating = rating;
                      });
                    },
                    punctualityRating,
                  ),
                  _buildRatingQuestion(
                    '¿Qué tan satisfecho estás con la precisión de la información brindada sobre el producto recibido?',
                        (rating) {
                      setState(() {
                        accuracyRating = rating;
                      });
                    },
                    accuracyRating,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (qualityRating > 0 &&
                        punctualityRating > 0 &&
                        accuracyRating > 0) {
                      await updateOrderStatus(orderModel.orderId);
                      // Guardar la encuesta en Firestore
                      await _saveSurveyToDatabase(
                        ownerId,
                        qualityRating,
                        punctualityRating,
                        accuracyRating,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRatingQuestion(
      String question, Function(int) onRatingChanged, int currentRating) {
    return Column(
      children: [
        Text(question),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                currentRating > index ? Icons.star : Icons.star_border,
              ),
              color: Colors.amber,
              onPressed: () {
                onRatingChanged(index + 1);
              },
            );
          }),
        ),
      ],
    );
  }

  Future<void> _saveSurveyToDatabase(
      String ownerId, int quality, int punctuality, int accuracy) async {
    DocumentReference surveyDoc = FirebaseFirestore.instance
        .collection("encuestas")
        .doc(ownerId);

    DocumentSnapshot surveySnapshot = await surveyDoc.get();

    if (surveySnapshot.exists) {
      Map<String, dynamic> existingData =
      surveySnapshot.data() as Map<String, dynamic>;

      int totalUsers = (existingData['usuariosEncuestados'] ?? 0) + 1;
      int totalQuality = (existingData['totalPregunta1'] ?? 0) + quality;
      int totalPunctuality = (existingData['totalPregunta2'] ?? 0) + punctuality;
      int totalAccuracy = (existingData['totalPregunta3'] ?? 0) + accuracy;

      await surveyDoc.update({
        'usuariosEncuestados': totalUsers,
        'totalPregunta1': totalQuality,
        'totalPregunta2': totalPunctuality,
        'totalPregunta3': totalAccuracy,
      });
    } else {
      await surveyDoc.set({
        'usuariosEncuestados': 1,
        'totalPregunta1': quality,
        'totalPregunta2': punctuality,
        'totalPregunta3': accuracy,
      });
    }
  }
  Future<void> updateOrderStatus(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection("userOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc(orderId)
          .update({"status": "calificado"});
      debugPrint("Estado de la orden actualizado a 'calificado'.");
    } catch (e) {
      debugPrint("Error al actualizar el estado de la orden: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Mis órdenes",
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
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No se encontraron órdenes"),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                OrderModel orderModel = snapshot.data![index];

                if (orderModel.status == "Entregado") {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    String? ownerId =
                    await findOwnerId(orderModel.products[0].id);
                    if (ownerId != null) {
                      _showSurveyDialog(context, ownerId, orderModel);
                    }
                  });
                }

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
                          child: Image.network(orderModel.products[0].image),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderModel.products[0].name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              orderModel.products.length > 1
                                  ? const SizedBox()
                                  : Column(
                                children: [
                                  Text(
                                    "Cantidad: ${orderModel.products[0].qty}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                              Text(
                                "Precio total: \$${orderModel.totalPrice}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Estado de orden: ${orderModel.status}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
