import 'package:conexion/constants/constants.dart';
import 'package:conexion/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/primary_button/primary_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isShowPassword = true;
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Cambiar contraseña",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          TextFormField(
            controller: newpassword,
            obscureText: isShowPassword,
            decoration: InputDecoration(
              hintText: "New Password",
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
          SizedBox(
            height: 24,
          ),
          TextFormField(
            controller: confirmpassword,
            obscureText: isShowPassword,
            decoration: InputDecoration(
              hintText: "Confirmar Contraseña",
              prefixIcon: const Icon(
                Icons.key_off_outlined,
              ),

            ),
          ),
          SizedBox(
            height: 36,
          ),
          PrimaryButton(
            title: "Update",
            onPressed: () async {
              if (newpassword.text.isEmpty) {
                showMessage("Nueva contraseña vacio");
              } else if (confirmpassword.text.isEmpty) {
                showMessage("Confirmar constraseña vacio");
              } else if (confirmpassword.text == newpassword.text) {
                FirebaseAuthHelper.instance
                    .changePassword(newpassword.text, context);
              } else {
                showMessage("Contraseñas no coinciden");
              }
            },
          )
        ],
      ),
    );
  }
}
