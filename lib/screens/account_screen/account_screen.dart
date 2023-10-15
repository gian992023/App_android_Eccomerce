import 'package:conexion/constants/routes.dart';
import 'package:conexion/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:conexion/screens/change_password/change_password.dart';
import 'package:conexion/screens/edit_profile/edit_profile.dart';
import 'package:conexion/screens/favourite_screen/favourite_screen.dart';
import 'package:conexion/widgets/primary_button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Cuenta",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: Column(
              children: [
                appProvider.getUserInformation.image == null
                    ? const Icon(
                        Icons.person_outline,
                        size: 120,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(appProvider.getUserInformation.image!),
                        radius: 70),
                Text(
                  appProvider.getUserInformation.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  appProvider.getUserInformation.email,
                ),
                SizedBox(
                  height: 8.9,
                ),

                SizedBox(
                    width: 140,
                    height: 30,
                    child: PrimaryButton(
                      title: "Editar perfil",
                      onPressed: () {
                        Routes.instance.push(
                            widget: const EditProfile(), context: context);
                      },
                    ))
              ],
            ),

          ),

          Expanded(

            flex: 2,
            child: Container(

              child: Column(
                children: [

                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.shopping_bag_outlined),
                    title: Text("Tus pedidos"),
                  ),
                  ListTile(
                    onTap: () {
                      Routes.instance.push(widget: const FavouriteScreen(), context: context);
                    },
                    leading: Icon(Icons.favorite_outline),
                    title: Text("Favoritos"),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.info_outline),
                    title: Text("Acerca de mi"),
                  ),
                  ListTile(
                    onTap: () {
                      Routes.instance.push(widget: const ChangePassword(), context: context);
                    },
                    leading: Icon(Icons.change_circle_outlined),
                    title: Text("Cambiar contraseña"),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.support_outlined),
                    title: Text("Soporte"),
                  ),
                  ListTile(
                    onTap: () {
                      FirebaseAuthHelper.instance.signOut();
                      setState(() {});
                    },
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Cerrar sesion"),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text("Version 1.0")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
