
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spotify/controller/Authentication/auth_services.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance; 


class Storedata {
  
  Future<String> uploadIMg(String childname,Uint8List file) async{

    Reference ref= storage.ref().child(childname);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }



  Future<String> saveUserData({
    required String uid,
    required String name,
    required String email,
  }) async {
    String res = "Some error occurred";
    try {
      
      await firestore.collection('userprofile').doc(uid).set({
        'name': name,
        'email': email,
        'profile_image_url': '', 
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

   Future<String> updateUserProfileImage({
    required String uid,
    required String imageUrl,
  }) async {
    String res = "Some error occurred";
    try {
      
      await firestore.collection('userprofile').doc(uid).update({
        'profile_image_url': imageUrl,
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }


}