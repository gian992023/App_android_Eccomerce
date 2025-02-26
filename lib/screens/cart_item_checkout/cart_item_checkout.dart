import 'package:conexion/constants/routes.dart';
import 'package:conexion/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:conexion/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:conexion/stripe_helper/stripe_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../provider/app_provider.dart';
import '../../widgets/primary_button/primary_button.dart';

class CartItemCheckout extends StatefulWidget {
  const CartItemCheckout({
    super.key,
  });

  @override
  State<CartItemCheckout> createState() => _CartItemCheckoutState();
}

class _CartItemCheckoutState extends State<CartItemCheckout> {
  int groupValue = 1;

  // Función para enviar el correo automáticamente usando EmailJS
  Future<void> sendEmail(String userName, String userEmail, List<Map<String, dynamic>> products) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = "service_92nonlk";
    const templateId = "template_dhd6n6f";
    const userId = "hyJr3TU2rO1c3_QDA";

    // Construir el mensaje del correo con los productos comprados
    String productDetails = '';
    for (var product in products) {
      productDetails += 'Producto: ${product["name"]}, Cantidad: ${product["qty"]}, Precio: \$${product["price"]}\n';
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": userId,
        "template_params": {
          "name": userName,
          "user_email": userEmail,
          "subject": "Pedido Ecommerce",
          "message": "Hola, $userName acabas de registrar una compra en nuestra app. Tu pedido es:\n$productDetails",
        }
      }),
    );

    if (response.statusCode == 200) {
      print("Email enviado correctamente");
    } else {
      print("Error al enviar el email: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
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
                  Icon(Icons.store),
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
              title: "Hacer pedido",
              onPressed: () async {
                if (groupValue == 1) {
                  // Obtener la información del usuario y los productos para el correo
                  String userName = appProvider.getUserInformation.name;
                  String userEmail = appProvider.getUserInformation.email;
                  List<Map<String, dynamic>> products = appProvider.getBuyProductList
                      .map((product) => {
                    "name": product.name,"qty": product.qty,"price": product.price
                  }).toList();
                  bool value = await FirebaseFirestoreHelper.instance.uploadOrderedProductFirebase(
                      appProvider.getBuyProductList,
                      context,"Pago en efectivo","pago");
                  // Limpiar el carrito de compras
                  appProvider.clearBuyProduct();
                  if (value) {
                    // Enviar correo con los detalles del pedido
                    await sendEmail(userName, userEmail, products);
                    // Navegar a la pantalla principal después de un retraso
                    Future.delayed(const Duration(seconds: 2), () {
                      Routes.instance.push(
                          widget: const CustomBottomBar(initialIndex: 2), context: context);
                    });
                  }
                } else {
                  // Procesar el pago con Stripe
                  int value = double.parse(appProvider.totalPriceBuyProductList().toString())
                      .round()
                      .toInt();
                  String totalPrice = (value * 100).toString();
                  await StripeHelper.instance.makePayment(totalPrice.toString(), context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
