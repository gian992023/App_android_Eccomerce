import 'package:conexion/screens/favourite_screen/widgets/single_favourite_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.cyan,
        title: const Text(
          "Vista de carta",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: appProvider.getFavouriteProductList.isEmpty
          ? const Center(
        child: Text("Vacio"),
      )
          : ListView.builder(
          itemCount: appProvider.getFavouriteProductList.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (ctx, index) {
            return SingleFavouriteItem(
              singleProduct: appProvider.getFavouriteProductList[index],
            );
          }),
    );
  }
}
