import 'package:flutter/material.dart';
import 'package:whatsapp/model/the_user.dart';
import 'package:whatsapp/screens/configs.dart';
import 'package:whatsapp/screens/home.dart';
import 'package:whatsapp/screens/login.dart';
import 'package:whatsapp/screens/messages.dart';
import 'package:whatsapp/screens/register.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings settings) {

    final args = settings.arguments as TheUser?;

    switch( settings.name ) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const Login()
        );
      case '/login':
        return MaterialPageRoute(
            builder: (_) => const Login()
        );
      case '/register':
        return MaterialPageRoute(
            builder: (_) => const Register()
        );
      case '/home':
        return MaterialPageRoute(
            builder: (_) => const Home()
        );
      case '/configs':
        return MaterialPageRoute(
            builder: (_) => const Configs()
        );
      case '/messages':
        return MaterialPageRoute(
            builder: (_) => Messages(args)
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