import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conexion/constants/routes.dart';
import 'package:conexion/models/product_model/product_model.dart';
import 'package:conexion/provider/app_provider.dart';
import 'package:conexion/screens/cart_screen/cart_screen.dart';
import 'package:conexion/screens/check_out/check_out.dart';
import 'package:conexion/screens/favourite_screen/favourite_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetails({Key? key, required this.singleProduct})
      : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}
class _ProductDetailsState extends State<ProductDetails> {
  int qty = 1;
  String? ownerId;
  String? categoryId;
  String? businessName;
  @override
  void initState() {
    super.initState();
    _fetchOwnerId();
    _fetchCategoryId();
  }
  Future<void> _fetchCategoryId() async {
    String? foundCategoryId = await findcategoryId(widget.singleProduct.id);
    if (foundCategoryId != null) {
      setState(() {
        categoryId = foundCategoryId;
      });
    }
  }
  Future<String?> findcategoryId(String productId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collectionGroup("userProducts").get();
    for (var doc in querySnapshot.docs) {
      QuerySnapshot categoriesQuerySnapshot = await FirebaseFirestore.instance
          .collection("userProducts")
          .doc(doc.id)
          .collection("categories")
          .get();
      for (var categoryDoc in categoriesQuerySnapshot.docs) {
        QuerySnapshot productsQuerySnapshot = await FirebaseFirestore.instance
            .collection("userProducts")
            .doc(doc.id)
            .collection("categories")
            .doc(categoryDoc.id)
            .collection("products")
            .get();
        for (var productDoc in productsQuerySnapshot.docs) {
          var data = productDoc.data() as Map<String, dynamic>?;
          if (data != null && data['id'] == productId) {
            // Devolver el ID de la categoría en lugar del ownerId
            return categoryDoc.id;
          }
        }
      }
    }
    return null;
  }
  Future<void> _fetchOwnerId() async {
    String? foundOwnerId = await findDocumentId(widget.singleProduct.id);
    if (foundOwnerId != null) {
      setState(() {
        ownerId = foundOwnerId;
        _fetchBusinessName(foundOwnerId);
      });
    }
  }
  Future<String?> findDocumentId(String productId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collectionGroup("userProducts").get();

    for (var doc in querySnapshot.docs) {
      QuerySnapshot categoriesQuerySnapshot = await FirebaseFirestore.instance
          .collection("userProducts")
          .doc(doc.id)
          .collection("categories")
          .get();
      for (var categoryDoc in categoriesQuerySnapshot.docs) {
        QuerySnapshot productsQuerySnapshot = await FirebaseFirestore.instance
            .collection("userProducts")
            .doc(doc.id)
            .collection("categories")
            .doc(categoryDoc.id)
            .collection("products")
            .get();
        for (var productDoc in productsQuerySnapshot.docs) {
          var data = productDoc.data() as Map<String, dynamic>?;
          if (data != null && data['id'] == productId) {
            return doc.id;
          }
        }
      }
    }
    return null;
  }
  Future<String?> findBussinesUser(String ownerId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("businessusers")
        .doc(ownerId)
        .get();
    if (snapshot.exists) {
      return snapshot.data()?['name'];
    }
    return null;
  }
  Future<void> _fetchBusinessName(String ownerId) async {
    String? name = await findBussinesUser(ownerId);
    if (name != null) {
      setState(() {
        businessName = name;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BusinessPrint(ownerId: ownerId)),
                      );
                    },
                    child: Text(
                      businessName ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.network(
                    widget.singleProduct.image,
                    height: 300,
                    width: 400,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.singleProduct.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.singleProduct.isFavourite =
                            !widget.singleProduct.isFavourite;
                          });
                          if (widget.singleProduct.isFavourite) {
                            appProvider
                                .addFavouriteProduct(widget.singleProduct);
                          } else {
                            appProvider
                                .removeFavouriteProduct(widget.singleProduct);
                          }
                        },
                        icon: Icon(appProvider.getFavouriteProductList
                            .contains(widget.singleProduct)
                            ? Icons.favorite
                            : Icons.favorite_border_outlined),
                      )
                    ],
                  ),
                  Text(widget.singleProduct.description),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          if (qty >= 1) {
                            setState(() {
                              qty--;
                            });
                          }
                        },
                        padding: EdgeInsets.zero,
                        child: CircleAvatar(
                          child: Icon(Icons.remove),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        qty.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          setState(() {
                            qty++;
                          });
                        },
                        padding: EdgeInsets.zero,
                        child: CircleAvatar(
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          ProductModel productModel =
                          widget.singleProduct.copyWith(qty: qty);
                          appProvider.addCartProduct(productModel);
                          showMessage("Agregado al carrito");
                        },
                        child: const Text(
                          "Agregar al carrito",
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      SizedBox(
                        height: 38,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () async {
                            ProductModel productModel = widget.singleProduct.copyWith(qty: qty);
                            String? ownerId = await findDocumentId(widget.singleProduct.id);
                            String? CategoryId = await findcategoryId(widget.singleProduct.id);
                            if (ownerId != null) {
                              int availableQty = widget.singleProduct.qty!;
                              if (availableQty >= qty) {
                                // Realizar la compra
                                int newQty = widget.singleProduct.qty! - qty;
                                await FirebaseFirestore.instance
                                    .collection("userProducts")
                                    .doc(ownerId)
                                    .collection("categories")
                                    .doc(CategoryId)
                                    .collection("products")
                                    .doc(widget.singleProduct.id)
                                    .update({'qty': newQty});
                                // Continuar con la compra
                                Routes.instance.push(
                                  widget: Checkout(
                                    singleProduct: productModel,
                                  ),
                                  context: context,
                                );
                              } else {
                                showMessage("No hay suficiente inventario");
                              }
                            } else {
                              // Manejar el caso en que ownerId sea null
                            }
                          },
                          child: const Text("Comprar ahora"
                          ,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class BusinessPrint extends StatelessWidget {
  final String? ownerId;

  const BusinessPrint({Key? key, required this.ownerId}) : super(key: key);

  Future<List<ProductModel>> getUserProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection("userProducts")
          .doc(ownerId)
          .collection("categories")
          .get();
      List<ProductModel> userProductsList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
      in querySnapshot.docs) {
        QuerySnapshot<Map<String, dynamic>> productsSnapshot =
        await doc.reference.collection("products").get();
        List<ProductModel> products = productsSnapshot.docs
            .map((e) => ProductModel.fromJson(e.data()))
            .toList();
        userProductsList.addAll(products);
      }

      return userProductsList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>?> findBussinesUser(String ownerId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("businessusers")
        .doc(ownerId)
        .get();

    if (snapshot.exists) {
      return {
        'image': snapshot.data()?['image'],
        'name': snapshot.data()?['name'],
        'email': snapshot.data()?['email'],
      };
    }

    return null;
  }

  Future<LatLng?> getBusinessLocation(String ownerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("mapas")
          .doc(ownerId)
          .get();

      if (snapshot.exists) {
        String? address = snapshot.data()?['address'];
        if (address != null && address.isNotEmpty) {
          return await _getCoordinatesFromAddress(address);
        }
      }
    } catch (e) {
      print('Error al obtener la ubicación del negocio: $e');
    }

    return null;
  }

  /// Obtiene las coordenadas a partir de una dirección usando la API de Google Maps
  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    const String _googleApiKey = "AIzaSyDN6oYrSPCNj2rD5oa9GCqahkIpPXS33eI";

    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        } else {
          print('No se encontraron resultados para la dirección.');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener coordenadas: $e');
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Print'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: getUserProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<ProductModel> products = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<Map<String, dynamic>?>(
                      future: findBussinesUser(ownerId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          Map<String, dynamic>? businessUserData =
                              snapshot.data;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Center(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      businessUserData?['image'] ?? ''),
                                  radius: 100,
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Text(
                                  businessUserData?['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Center(
                                child: Text(
                                  businessUserData?['email'] ?? '',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              Divider(),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    LatLng? location =
                                    await getBusinessLocation(ownerId!);

                                    if (location != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapScreen(
                                            location: location,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Ubicación no disponible para este negocio'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Ver en el mapa'),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text('No hay datos'),
                          );
                        }
                      },
                    ),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        ...products.map((product) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    singleProduct: product,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              child: Card(
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.cover,
                                        width:
                                        MediaQuery.of(context).size.width /
                                            2 -
                                            24,
                                        height: 200,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            product.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Cantidad: ${product.qty}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text('No hay datos'),
            );
          }
        },
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final LatLng location;

  const MapScreen({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa del negocio'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('businessLocation'),
            position: location,
          ),
        },
      ),
    );
  }
}