import 'package:conexion/constants/routes.dart';
import 'package:conexion/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:conexion/models/category_model/category_model.dart';
import 'package:conexion/provider/app_provider.dart';
import 'package:conexion/screens/category_view/category_view.dart';
import 'package:conexion/screens/product_detail/product_details.dart';
import 'package:conexion/widgets/top_titles/top_titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model/product_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productModelList = [];
  bool isLoading = false;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();

    getCategoryList();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();
    productModelList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];

  void searchProducts(String value) {
    searchList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    print(searchList.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TopTitles(subtitle: "", title: "Mi comercio"),
                        TextFormField(
                          controller: search,
                          onChanged: (String value) {
                            searchProducts(value);
                          },
                          decoration:
                              const InputDecoration(hintText: "Search..."),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          "Categorias",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  categoriesList.isEmpty
                      ? const Center(
                          child: Text("Categorias vacias"),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoriesList
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Routes.instance.push(
                                              widget: CategoryView(
                                                  categoryModel: e),
                                              context: context);
                                        },
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(e.image),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                  const SizedBox(
                    height: 12,
                  ),
                  !isSearched()
                      ? const Padding(
                          padding: EdgeInsets.only(top: 12.0, left: 12),
                          child: Text(
                            "Mas vendidos",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : SizedBox.fromSize(),
                  const SizedBox(
                    height: 12,
                  ),
                  search.text.isNotEmpty && searchList.isEmpty
                      ? Center(
                          child: Text("Producto no encontrado"),
                        )
                      : searchList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                  padding: EdgeInsets.only(bottom: 50),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: searchList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 30,
                                          childAspectRatio: 0.7,
                                          crossAxisCount: 2),
                                  itemBuilder: (ctx, index) {
                                    ProductModel singleProduct =
                                        searchList[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Image.network(
                                            singleProduct.image,
                                            height: 100,
                                            width: 100,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            singleProduct.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              "price: \$${singleProduct.price}"),
                                          Text(
                                            singleProduct.qty == 0 ? 'Agotado' : 'Cantidad: ${singleProduct.qty}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 45,
                                            width: 120,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                if (singleProduct.qty == 0) {
                                                  // Mostrar un alert indicando que el inventario está agotado
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text("Inventario Agotado"),
                                                        content: const Text("Lo sentimos, este producto está agotado."),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Text("Aceptar"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  // El inventario no está agotado, navegar a ProductDetails
                                                  Routes.instance.push(
                                                    widget: ProductDetails(singleProduct: singleProduct),
                                                    context: context,
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                "Buy",
                                              ),
                                            ),

                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : productModelList.isEmpty
                              ? const Center(
                                  child: Text("Sin productos"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      padding: EdgeInsets.only(bottom: 50),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: productModelList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 20,
                                              crossAxisSpacing: 30,
                                              childAspectRatio: 0.65,
                                              crossAxisCount: 2),
                                      itemBuilder: (ctx, index) {
                                        ProductModel singleProduct =
                                            productModelList[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Image.network(
                                                singleProduct.image,
                                                height: 100,
                                                width: 100,
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                singleProduct.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "price: \$${singleProduct.price}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                singleProduct.qty == 0 ? 'Agotado' : 'Cantidad: ${singleProduct.qty}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              SizedBox(
                                                height: 45,
                                                width: 120,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    if (singleProduct.qty == 0) {
                                                      // Mostrar un alert indicando que el inventario está agotado
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text("Inventario Agotado"),
                                                            content: const Text("Lo sentimos, este producto está agotado."),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Text("Aceptar"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      // El inventario no está agotado, navegar a ProductDetails
                                                      Routes.instance.push(
                                                        widget: ProductDetails(singleProduct: singleProduct),
                                                        context: context,
                                                      );
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Buy",
                                                  ),
                                                ),

                                              ),

                                            ],
                                          ),
                                        );
                                      }),
                                ),
                  const SizedBox(
                    height: 12,
                  )
                ],
              ),
            ),
    );
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else if (search.text.isEmpty && searchList.isNotEmpty) {
      return false;
    } else if (searchList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
