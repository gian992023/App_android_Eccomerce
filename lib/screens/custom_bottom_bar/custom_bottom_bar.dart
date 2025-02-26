import 'package:conexion/screens/account_screen/account_screen.dart';
import 'package:conexion/screens/cart_screen/cart_screen.dart';
import 'package:conexion/screens/favourite_screen/favourite_screen.dart';
import 'package:conexion/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../order_screen/order_screen.dart';

class CustomBottomBar extends StatefulWidget {
  final int initialIndex; // Nuevo parámetro para recibir el índice inicial
  const CustomBottomBar({
    Key? key,
    this.initialIndex = 0, // Valor predeterminado es la primera pestaña (Home)
  }) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.initialIndex); // Inicializa con el índice recibido
  }

  List<Widget> _buildScreens() => [
    const Home(),
    const CartScreen(),
    const OrderScreen(),
    const AccountScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      inactiveIcon: const Icon(Icons.home_outlined),
      title: "Home",
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.shopping_cart),
      inactiveIcon: const Icon(Icons.shopping_cart_outlined),
      title: "Carrito",
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.fact_check_rounded),
      inactiveIcon: const Icon(Icons.fact_check_outlined),
      title: "Ordenes",
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      inactiveIcon: const Icon(Icons.person_outline),
      title: "perfil",
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      resizeToAvoidBottomInset: true,
      navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
          ? 0.0
          : kBottomNavigationBarHeight,
      bottomScreenMargin: 0,
      backgroundColor: Theme.of(context).primaryColor,
      hideNavigationBar: false,
      decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
      ),
      navBarStyle: NavBarStyle.style1,
    ),
  );
}
