import 'package:conexion/constants/asset_images.dart';
import 'package:conexion/constants/routes.dart';
import 'package:conexion/screens/auth_ui/sign_up/sign_up.dart';
import 'package:conexion/widgets/top_titles/top_titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/primary_button/primary_button.dart';
import '../login/login.dart';
//Clase vista de bienvenida login
class Bienvenido extends StatelessWidget {
  const Bienvenido({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopTitles(
              subtitle: "Comprar cualquier producto desde cualquier lugar",
              title: "Bienvenido",
            ),
            Center(
              child: Image.asset(
                AssetsImages.instance.otroImage,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.facebook,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    AssetsImages.instance.esteImage,
                    scale: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            PrimaryButton(
              title: "Iniciar sesion",
              onPressed: () {
                Routes.instance.push(widget: const Login(), context: context);
              },
            ),
            const SizedBox(
              height: 18,
            ),
            PrimaryButton(
              title: "Registrarse",
              onPressed: () {
                Routes.instance
                    .push(widget: const SignUp(), context: context);
              },
            ),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
