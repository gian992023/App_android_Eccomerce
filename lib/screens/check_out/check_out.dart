import 'package:conexion/constants/routes.dart';
import 'package:conexion/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:conexion/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:conexion/models/product_model/product_model.dart';
import 'package:conexion/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 3),
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
                    "Pagar en efectivo",
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
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 3),
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
                    "Pago en linea",
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
              title: "Continuar",
              onPressed: () async {
                appProvider.clearBuyProduct();
                appProvider.addBuyProduct(widget.singleProduct);
                bool value = await FirebaseFirestoreHelper.instance
                    .uploadOrderedProductFirebase(
                  appProvider.getBuyProductList,
                  context, groupValue==1?"Pago en efectivo": "Pago"
                );
                if (value) {
                  Future.delayed(const Duration(seconds: 2), () {
                    Routes.instance.push(
                        widget: const CustomBottomBar(), context: context);
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
