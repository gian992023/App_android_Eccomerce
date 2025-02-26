import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:conexion/models/product_model/product_model.dart';
import '../product_detail/product_details.dart';

class CustomerPromotionsView extends StatelessWidget {
  const CustomerPromotionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(


        physics: const AlwaysScrollableScrollPhysics(),
        child:

        StreamBuilder<QuerySnapshot>(

          stream: FirebaseFirestore.instance.collection("userProducts").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No hay usuarios con productos"));
            }

            var users = snapshot.data!.docs;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: users.map((userDoc) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("userProducts")
                      .doc(userDoc.id)
                      .collection("categories")
                      .snapshots(),
                  builder: (context, categorySnapshot) {
                    if (categorySnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!categorySnapshot.hasData || categorySnapshot.data!.docs.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    var categories = categorySnapshot.data!.docs;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categories.map((categoryDoc) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("userProducts")
                              .doc(userDoc.id)
                              .collection("categories")
                              .doc(categoryDoc.id)
                              .collection("products")
                              .where("isOnPromotion", isEqualTo: true)
                              .snapshots(),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            var products = productSnapshot.data!.docs.map((doc) {
                              return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
                            }).toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: products.map((product) {
                                double discountPercentage =
                                    ((product.price - product.discountedPrice) / product.price) * 100;

                                return Card(
                                  color: Colors.white,
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: Image.network(
                                            product.image,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(product.name),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "\$${product.discountedPrice.toStringAsFixed(2)} AHORA",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "\$${product.price.toStringAsFixed(2)} ANTES",
                                                style: const TextStyle(
                                                  decoration: TextDecoration.lineThrough,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                "${discountPercentage.toStringAsFixed(0)}% Descuento",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProductDetails(singleProduct: product),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
