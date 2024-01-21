// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:conexion/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:conexion/models/create_product_model/create_producto_model.dart';
import 'package:conexion/widgets/top_titles/top_titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/routes.dart';
import '../../constants/constants.dart';
import '../../firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import '../../models/category_model/category_model.dart';
//import '../view_products_business/view_products_business.dart';
class RegisterProduct extends StatefulWidget {
  const RegisterProduct({super.key});
  @override
  State<RegisterProduct> createState() => _RegisterProductState();
}
class _RegisterProductState extends State<RegisterProduct> {
  String? selectedCategoryId;
  CategoryModel? selectedCategory;

  late Future<List<CategoryModel>> categories;

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection("categories").get();
      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();
      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }



  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  //final TextEditingController _categoriesController = TextEditingController();
  @override



  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    _stateController.dispose();
    //_categoriesController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopTitles(
                    subtitle: "Registra tu producto", title: "Registro productos"),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child:CupertinoButton(
                    onPressed: () {
                      takePicture();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          if (image != null)
                            Image.file(
                              image!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black, // Ajusta el color del icono según tus necesidades
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Producto',
                      prefixIcon: Icon(
                        Icons.shopping_cart,
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),FutureBuilder<List<CategoryModel>>(
            future: getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No hay categorías disponibles');
              } else {
                List<CategoryModel> categoriesList = snapshot.data!;
                if (selectedCategory == null) {
                  selectedCategory = categoriesList.isNotEmpty
                      ? categoriesList[0]
                      : null;
                }

                return DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategoryId = newValue;
                    });
                  },
                  items: categoriesList
                      .map<DropdownMenuItem<String>>(
                        (CategoryModel category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    },
                  ).toList(),
                  decoration: InputDecoration(
                    labelText: 'Seleccione una categoría',
                  ),
                );
              }
            },
          ),
                SizedBox(
                  height: 20,
                ),


                TextFormField(
                    controller: _qtyController,
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                      prefixIcon: Icon(
                        Icons.format_list_numbered,
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripcion',
                      prefixIcon: Icon(
                        Icons.description,
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Precio',
                      prefixIcon: Icon(
                        Icons.attach_money,
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Alinea los botones al centro horizontal
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text('Agregar Producto'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Ver productos'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
  void _submitForm() async {
    String name = _nameController.text;
    String description = _descriptionController.text;
    int qty = int.tryParse(_qtyController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0.0;
    String categoryId = selectedCategoryId ?? "Otra Categoría";


    // Subir la imagen al storage
    String imageUrl = await FirebaseStorageHelper().uploadProductImage(image!);
    // Crear el objeto CreateProductModel con la URL de la imagen
    CreateProductModel product = CreateProductModel(
    image: imageUrl,  // Establecer la URL de la imagen
    id: '',
    name: name,
    price: price,
    description: description,
    qty: qty,
    );
    // Crear el producto en Firestore
    FirebaseFirestoreHelper().createProductFirebase(product, context, categoryId);
  }}