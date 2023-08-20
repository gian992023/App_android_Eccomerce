import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xffe16555),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Cargando..."),
            ),
          ],
        ),
      );
    }),
  );
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return alert;
      },
  );
}
String getMessageFromErrorCode(String errorCode){
  switch (errorCode){
    case "ERROR_EMAIL_ALREADY_IN_USE":
      return "Correo electronico ya fue usado. Ir a la página de inicio de sesión";
    case "account-exist-with-different-credential":
      return "Correo electronico ya fue usado. Ir a la página de inicio de sesión";
    case "email-already-in-use":
      return "Correo electronico ya fue usado. Ir a la página de inicio de sesión";
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return"Contraseña Incorrecta";
    case "ERROR_USER_NOT_FOUND":
      return"Ningun usuario encontrado con este correo";
    case "user-not-found":
      return"Ningun usuario encontrado con este correo";
    case "ERROR_USER_DISABLED":
      return"Usuario Deshabilitado";
    case "user-disabled":
      return"Usuario Deshabilitado";
    case "ERROR_TOO_MANY_RESQUESTS":
      return"Demasiadas solicitudes para iniciar sesión en esta cuenta";
    case "operation-not-allowed":
      return"Demasiadas solicitudes para iniciar sesión en esta cuenta";
    case "ERROR_OPERATION_NOT_ALLOWED":
      return"Demasiadas solicitudes para iniciar sesión en esta cuenta";
    case "ERROR_INVALID_EMAIL":
      return"Correo electronico es invalido";
    case "invalid_email":
      return"Correo electronico es invalido";

    default:
      return "Inicio de sesion fallo, porfavor intente nuevamente";
  }
}

bool loginValidation(String email,String password){
  if(email.isEmpty && password.isEmpty){
    showMessage("Ambos espacios estan vacios");
    return false;
  }
  else if(email.isEmpty){
    showMessage("correo electronico vacio");
    return false;
  }
  else if(password.isEmpty){
    showMessage("Contraseña vacia");
    return false;

  }else {
    return true;
  }
}
bool singUpValidation(String email,String password,String name,String phone){
  if(email.isEmpty && password.isEmpty && name.isEmpty && phone.isEmpty){
    showMessage("Ambos espacios estan vacios");
    return false;
  }
  else if(email.isEmpty){
    showMessage("correo electronico vacio");
    return false;
  }
  else if(password.isEmpty){
    showMessage("contraseña vacia");
    return false;

  }
  else if(name.isEmpty){
    showMessage("Nombre vacio");
    return false;
  }
  else if(phone.isEmpty){
    showMessage("Numero telefonico vacio");
    return false;

  }
  else {
    return true;
  }
}