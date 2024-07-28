// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:developer';

import 'package:pizza_app/Models/UserModel.dart';
final FirebaseFirestore store = FirebaseFirestore.instance;
final CollectionReference reference = store.collection("User");

class UserData {
  static userdata(String uid, String email) async {
    Usermodel d = Usermodel(uid: uid, email: email);
    try {
      await store.collection("User").doc(uid).set(d.toMap());
    } catch (e) {

      log(e.toString());
    }
  }
  
}
