import 'dart:convert';

import 'package:conexion/models/product_model/product_model.dart';





class OrderModel {
  OrderModel({
    required this.totalPrice,
    required this.orderId,
    required this.payment,
    required this.products,
    required this.status,

  });

  String orderId;
  String status;
  List<ProductModel> products;
  String payment;
  double totalPrice;


  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> productMap=json["products"];
    return OrderModel(
        orderId: json["orderId"],
        totalPrice: json["totalPrice"],
        products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
        status: json["status"],
        payment: json["payment"]);
  }


}
