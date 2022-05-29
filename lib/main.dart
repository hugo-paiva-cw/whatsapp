import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/screens/login.dart';

void main() async {

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //
  // FirebaseFirestore db = FirebaseFirestore.instance;
  // db.collection('users')
  // .doc('001')
  // .set( {'name': 'Hugo'} );
  //

  runApp(MaterialApp(
    home: const Login(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color(0xff075E54), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff25D366)),
    ),
  ));

}
