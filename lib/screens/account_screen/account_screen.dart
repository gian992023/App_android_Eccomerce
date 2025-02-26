import 'package:conexion/constants/routes.dart';
import 'package:conexion/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:conexion/screens/change_password/change_password.dart';
import 'package:conexion/screens/edit_profile/edit_profile.dart';
import 'package:conexion/screens/favourite_screen/favourite_screen.dart';
import 'package:conexion/screens/order_screen/order_screen.dart';
import 'package:conexion/widgets/primary_button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../maps/maps_google.dart';
import '../../provider/app_provider.dart';
import '../events/eventos_usuarios.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Cuenta",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: appProvider.getUserInformation.image == null
                        ? const Icon(Icons.person_outline, size: 120)
                        : CircleAvatar(
                      backgroundImage:
                      NetworkImage(appProvider.getUserInformation.image!),
                      radius: screenWidth * 0.15,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    appProvider.getUserInformation.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(appProvider.getUserInformation.email),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.05,
                    child: PrimaryButton(
                      title: "Editar perfil",
                      onPressed: () {
                        Routes.instance.push(
                          widget: const EditProfile(),
                          context: context,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Column(
                    children: [
                      _buildListTile(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        title: "Tus pedidos",
                        onTap: () {
                          Routes.instance.push(
                            widget: const OrderScreen(),
                            context: context,
                          );
                        },
                      ),
                      _buildListTile(
                        context,
                        icon: Icons.favorite_outline,
                        title: "Favoritos",
                        onTap: () {
                          Routes.instance.push(
                            widget: const FavouriteScreen(),
                            context: context,
                          );
                        },
                      ),
                      _buildListTile(
                        context,
                        icon: Icons.map,
                        title: "Ver Mapa",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapPage(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        context,
                        icon: Icons.change_circle_outlined,
                        title: "Cambiar contraseña",
                        onTap: () {
                          Routes.instance.push(
                            widget: const ChangePassword(),
                            context: context,
                          );
                        },
                      ),
                      _buildListTile(
                        context,
                        icon: Icons.event,
                        title: "Eventos",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventsListScreen(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        context,
                        icon: Icons.exit_to_app,
                        title: "Cerrar sesión",
                        onTap: () {
                          FirebaseAuthHelper.instance.signOut();
                          setState(() {});
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text("Versión 1.0"),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: MediaQuery.of(context).size.width * 0.07),
      title: Text(
        title,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
      ),
    );
  }
}
