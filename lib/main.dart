import 'package:conexion/constants/theme.dart';
import 'package:conexion/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:conexion/firebase_helper/firebase_options/firebase_options.dart';
import 'package:conexion/provider/app_provider.dart';
import 'package:conexion/screens/auth_ui/bienvenido/bienvenido.dart';
import 'package:conexion/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  Stripe.publishableKey =
      "pk_test_51OAi11FgSZnDlJbfCDUKMZVdz25KcCOAQwIKL8Ll6KjA1dVw6IbGEMimhmrzKdxrvA0wNrrN7NBla94wqkn0vYGY00gMtS8VjU";
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Compy E Commerce',
          theme: themeData,
          home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const CustomBottomBar();
              }
              return const Bienvenido();
            },
          ),
        ));
  }
}
