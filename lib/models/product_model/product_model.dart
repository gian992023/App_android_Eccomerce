import 'dart:convert';

ProductModel userModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String ProductModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.image,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.isFavourite,
    this.qty,
    this.isOnPromotion = false, // Nuevo campo
    this.discountedPrice = 0.0, // Nuevo campo
  });

  String id;
  String name;
  String image;
  String description;
  bool isFavourite;
  double price;
  int? qty;
  bool isOnPromotion; // Nuevo campo
  double discountedPrice; // Nuevo campo

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    description: json["description"],
    isFavourite: json["isFavourite"] ?? false,
    qty: json["qty"],
    price: double.parse(json["price"].toString()),
    isOnPromotion: json["isOnPromotion"] ?? false, // Nuevo campo
    discountedPrice: json["discountedPrice"] ?? 0.0, // Nuevo campo
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "description": description,
    "price": price,
    "isFavourite": isFavourite,
    "qty": qty,
    "isOnPromotion": isOnPromotion, // Nuevo campo
    "discountedPrice": discountedPrice, // Nuevo campo
  };

  ProductModel copyWith({
    int? qty,
    bool? isOnPromotion,
    double? discountedPrice,
  }) =>
      ProductModel(
        image: image,
        id: id,
        name: name,
        price: price,
        description: description,
        qty: qty ?? this.qty,
        isFavourite: isFavourite,
        isOnPromotion: isOnPromotion ?? this.isOnPromotion, // Nuevo campo
        discountedPrice: discountedPrice ?? this.discountedPrice, // Nuevo campo
      );
}