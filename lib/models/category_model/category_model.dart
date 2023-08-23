import 'dart:convert';

CategoryModel userModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String CategoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.image,
    required this.id,
    required this.name,

  });

  String id;
  String name;

  String image;


  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,

  };
}
