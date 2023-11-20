// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:conexion/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constants/routes.dart';
import '../firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import '../screens/custom_bottom_bar/custom_bottom_bar.dart';
class StripeHelper {


static  StripeHelper instance = StripeHelper();
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(String amount, BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent("10000", 'COP');
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "CO", currencyCode: "COP", testEnv: true);
      //paso dos
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'
              ],
              style: ThemeMode.light,
              merchantDisplayName: 'Giancarlo',
              googlePay: gpay
          )).then((value) => {});
      //Paso tres: Display payment sheet
      displayPaymentSheet(context);

    } catch (err) {}
  }

  displayPaymentSheet(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        bool value = await FirebaseFirestoreHelper.instance
            .uploadOrderedProductFirebase(
            appProvider.getBuyProductList, context, "Pago");
        appProvider.clearBuyProduct();
        if (value) {
          Future.delayed(const Duration(seconds: 2), () {
            Routes.instance.push(
                widget: const CustomBottomBar(), context: context);
          });
        }
      });

    } catch (e) {

      print('$e');

    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'pk_test_51OAi11FgSZnDlJbfCDUKMZVdz25KcCOAQwIKL8Ll6KjA1dVw6IbGEMimhmrzKdxrvA0wNrrN7NBla94wqkn0vYGY00gMtS8VjU',
         'Content-Type': 'application/x-www-form-urlencoded'
          },
        body:body,
      );
      return json.decode(response.body);

    } catch (err) {
      throw Exception(err.toString());
    }
  }
}