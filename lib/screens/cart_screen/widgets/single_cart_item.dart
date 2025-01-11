import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conexion/models/product_model/product_model.dart';
import 'package:conexion/provider/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';

class SingleCartItem extends StatefulWidget {
  final ProductModel singleProduct;

  const SingleCartItem({super.key, required this.singleProduct});

  @override
  State<SingleCartItem> createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  int qty = 1;
  String? ownerId;
  String? businessName;

  @override
  void initState() {
    qty = widget.singleProduct.qty ?? 1;
    _fetchOwnerId(); // Buscar el ownerId cuando se inicializa el widget
    setState(() {});
    super.initState();
  }

  Future<void> _fetchOwnerId() async {
    String? foundOwnerId = await findDocumentId(widget.singleProduct.id);
    if (foundOwnerId != null) {
      setState(() {
        ownerId = foundOwnerId;
        _fetchBusinessName(
            foundOwnerId); // Buscar el nombre del negocio cuando se obtiene el ownerId
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
            return doc.id; // Retorna el ownerId (document id) del producto
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
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 3),
      ),
      child: Row(
        children: [
          // Sección de la imagen del producto
          Expanded(
            flex: 1, // Ajusta el tamaño del contenedor de la imagen
            child: Container(
              height: 150,
              color: Colors.red.withOpacity(0.5),
              child: Image.network(
                widget.singleProduct.image,
                fit: BoxFit.cover, // Asegura que la imagen se ajuste bien
              ),
            ),
          ),

          // Sección de la información del producto
          Expanded(
            flex: 2, // Ajusta el tamaño de esta sección en relación a la imagen
            child: SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Columna de información del producto
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          // Asegura que la columna use el espacio disponible
                          children: [
                            // Nombre del producto
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              // Ajusta el tamaño del texto si es necesario
                              child: Text(
                                widget.singleProduct.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Nombre del negocio (si está disponible)
                            if (businessName != null)
                              Text(
                                'Negocio: $businessName',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            // Contador de cantidad y botones de sumar/restar
                            Row(
                              children: [
                                CupertinoButton(
                                  onPressed: () {
                                    if (qty > 1) {
                                      setState(() {
                                        qty--;
                                      });
                                      appProvider.updateQty(
                                          widget.singleProduct, qty);
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  child: CircleAvatar(
                                    maxRadius: 13,
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                                Text(
                                  qty.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    setState(() {
                                      qty++;
                                    });
                                    appProvider.updateQty(
                                        widget.singleProduct, qty);
                                  },
                                  padding: EdgeInsets.zero,
                                  child: CircleAvatar(
                                    maxRadius: 13,
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                            // Botón de favoritos
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (!appProvider.getFavouriteProductList
                                    .contains(widget.singleProduct)) {
                                  appProvider.addFavouriteProduct(
                                      widget.singleProduct);
                                  showMessage("Agregado a favoritos");
                                } else {
                                  appProvider.removeFavouriteProduct(
                                      widget.singleProduct);
                                  showMessage("Removido de favoritos");
                                }
                              },
                              child: Text(
                                appProvider.getFavouriteProductList.contains(
                                    widget.singleProduct)
                                    ? "Remover de favoritos"
                                    : "Agregar a favoritos",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Precio del producto
                        Text(
                          "\$${widget.singleProduct.price.toString()}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Botón para eliminar el producto del carrito
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        appProvider.removeCartProduct(widget.singleProduct);
                        showMessage("Remover del carrito");
                      },
                      child: const CircleAvatar(
                        maxRadius: 13,
                        child: Icon(
                          Icons.delete,
                          size: 19,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}