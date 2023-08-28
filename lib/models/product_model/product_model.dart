import 'dart:convert';

ProductModel userModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String ProductModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({required this.image,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.status,
    required this.isFavourite,
    this.qty});

  String id;
  String name;
  String image;
  String description;
  bool isFavourite;
  double price;
  String status;
  int? qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        isFavourite: false,
        qty: json["qty"],
        price: double.parse(json["price"].toString()),
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "price": price,
        "status": status,
        "isFavourite": isFavourite,
        "qty": qty,
      };


  ProductModel copyWith({

    int? qty,
  }) =>
      ProductModel(image: image,
          id: id,
          name: name,
          price: price,
          description: description,
          status: status,
          qty: qty??this.qty,
          isFavourite: isFavourite,
      );
}
