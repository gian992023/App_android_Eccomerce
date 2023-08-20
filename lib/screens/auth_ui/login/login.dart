// ignore_for_file: use_build_context_synchronously

import 'package:conexion/constants/constants.dart';
import 'package:conexion/constants/routes.dart';
import 'package:conexion/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:conexion/screens/auth_ui/sign_up/sign_up.dart';
import 'package:conexion/screens/home/home.dart';
import 'package:conexion/widgets/primary_button/primary_button.dart';
import 'package:conexion/widgets/top_titles/top_titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopTitles(
                subtitle: "Bienvenido de nuevo a Compy",
                title: "Iniciar sesion"),
            const SizedBox(
              height: 46,
            ),
            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  )),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: password,
              obscureText: isShowPassword,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(
                  Icons.key_off_outlined,
                ),
                suffixIcon: CupertinoButton(
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                        print(isShowPassword);
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.visibility)),
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            PrimaryButton(
              title: "login",
              onPressed: () async {
                bool isValidated = loginValidation(email.text, password.text);
                if (isValidated) {
                  bool isLogined = await FirebaseAuthHelper.instance
                      .login(email.text, password.text, context);
                  if (isLogined) {
                    Routes.instance.pushAndRemoveUntil(
                        widget: const Home(), context: context);
                  }
                }
              },
            ),
            const SizedBox(
              height: 26,
            ),
            const Center(child: Text("¿No tienes una cuenta?")),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: CupertinoButton(
                onPressed: () {
                  Routes.instance
                      .push(widget: const SignUp(), context: context);
                },
                child: Text(
                  "Crea una cuenta",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
