import 'dart:convert';
import 'package:conexion/models/product_model/product_model.dart';
CreateProductModel userModelFromJson(String str) =>
    CreateProductModel.fromJson(json.decode(str));

String CreateProductModelToJson(CreateProductModel data) => json.encode(data.toJson());

class CreateProductModel {
  CreateProductModel({required this.image,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    //   required this.state,
  //required this.categories,

    this.qty});

  String id;
  String name;
  String image;
  String description;
//  bool state;
  //String categories;

  double price;
  int? qty;

  factory CreateProductModel.fromJson(Map<String, dynamic> json) =>
      CreateProductModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        //  state: json["state"],
          //categories: json["categories"],



        qty: json["qty"],
        price: double.parse(json["price"].toString()),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "price": price,
        //  "state":state,
        //"categories":categories,


        "qty": qty,
      };


  CreateProductModel copyWith({

    int? qty,
  }) =>
      CreateProductModel(image: image,
        id: id,
        name: name,
        price: price,
        description: description,
        //  state:state,
        //categories:categories,

        qty: qty??this.qty,

      );
}
