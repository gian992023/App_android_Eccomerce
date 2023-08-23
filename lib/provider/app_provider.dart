import 'package:conexion/models/product_model/product_model.dart';
import 'package:flutter/cupertino.dart';

class AppProvider with ChangeNotifier {
  //CARTA DE CARRITO
  final List<ProductModel> _cartProductList = [];
  void addCartProduct(ProductModel productModel) {
    _cartProductList.add(productModel);
    notifyListeners();
  }
  void removeCartProduct(ProductModel productModel){
    _cartProductList.remove(productModel);
    notifyListeners();
  }
  List<ProductModel> get getCartProductList => _cartProductList;
  // Favorito

  final List<ProductModel> _favouriteProductList = [];
  void addFavouriteProduct(ProductModel productModel) {
    _cartProductList.add(productModel);
    notifyListeners();
  }
  void removeFavouriteProduct(ProductModel productModel){
    _cartProductList.remove(productModel);
    notifyListeners();
  }
  List<ProductModel> get getFavouriteProductList => _cartProductList;
}