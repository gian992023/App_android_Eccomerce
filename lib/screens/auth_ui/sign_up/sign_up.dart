// ignore_for_file: use_build_context_synchronously
import 'package:conexion/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:conexion/constants/constants.dart';
import 'package:conexion/screens/auth_ui/login/login.dart';
import 'package:conexion/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:conexion/screens/home/home.dart';
import 'package:conexion/widgets/primary_button/primary_button.dart';
import 'package:conexion/widgets/top_titles/top_titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/routes.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
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
                subtitle: "Haz parte de Compy", title: "Crear usuario"),
            const SizedBox(
              height: 46,
            ),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                  hintText: "Nombre",
                  prefixIcon: Icon(
                    Icons.person_outlined,
                  )),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
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
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: "Telefono",
                  prefixIcon: Icon(
                    Icons.phone_android_outlined,
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
              title: "Crear cuenta",
              onPressed: () async {
                bool isValidated = singUpValidation(
                    email.text, password.text, name.text, phone.text);
                if (isValidated) {
                  bool isLogined = await FirebaseAuthHelper.instance
                      .singUp(name.text, email.text, password.text, context);
                  if (isLogined) {
                    Routes.instance.pushAndRemoveUntil(
                        widget: const CustomBottomBar(), context: context);
                  }
                }
              },
            ),
            const SizedBox(
              height: 26,
            ),
            const Center(child: Text("Ya tengo una cuenta")),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Iniciar sesion",
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
