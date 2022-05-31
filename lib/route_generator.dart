import 'package:flutter/material.dart';
import 'package:whatsapp/screens/configs.dart';
import 'package:whatsapp/screens/home.dart';
import 'package:whatsapp/screens/login.dart';
import 'package:whatsapp/screens/register.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings settings) {

    switch( settings.name ) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case '/login':
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case '/register':
        return MaterialPageRoute(
            builder: (_) => Register()
        );
      case '/home':
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case '/configs':
        return MaterialPageRoute(
            builder: (_) => Configs()
        );
      default:
        _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tela não encontrada!'),
            ),
            body: const Center(
              child: Text('Tela nao encontrada.'),
            ),
          );
        }
    );
  }

}