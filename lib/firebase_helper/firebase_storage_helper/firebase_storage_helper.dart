import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//clase obtencion y envio de informacion hacia el Storage de Firebase
class FirebaseStorageHelper {
  static FirebaseStorageHelper instance = FirebaseStorageHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;
//Funcion Subir imagenen de perfil de usuario a  firestore
  Future<String> uploadUserImage(File image) async {
    String userId=FirebaseAuth.instance.currentUser!.uid;
    TaskSnapshot taskSnapshot = await _storage.ref(userId).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
//Funcion subir imagen de producto usuario empresarial a firestore
Future<String> uploadProductImage(File image) async {
    String productId = DateTime.now().millisecondsSinceEpoch.toString();
    String storagePath = "product_images/$productId.jpg";
    TaskSnapshot taskSnapshot = await _storage.ref(storagePath).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}