import 'package:flutter/material.dart';
import 'package:whatsapp/route_generator.dart';
import 'package:whatsapp/screens/login.dart';
import 'dart:io';

void main() async {

  final ThemeData defaultThemeIOS = ThemeData(
      colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.grey[200], secondary: const Color(0xff25D366)));

  final ThemeData defaultThemeAndroid = ThemeData(
      colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0xff075E54),
          secondary: const Color(0xff25D366)));

  runApp(MaterialApp(
    home: const Login(),
    debugShowCheckedModeBanner: false,
    theme: Platform.isIOS ? defaultThemeIOS : defaultThemeAndroid,
    initialRoute: '/',
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
