import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp/screens/register.dart';

import '../model/the_user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = '';

  _validateFields() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains('@')) {
      if (password.length >= 6) {
        setState(() {
          _errorMessage = '';
        });

        TheUser user = TheUser();
        user.email = email;
        user.password = password;

        _signInUser(user);
      } else {
        setState(() {
          _errorMessage = 'Preencha a senha. Pelo menos 6 caracteres.';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Preencha o email utilizando @.';
      });
    }
  }

  _signInUser(TheUser user) async {
    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((value) {

      Navigator.pushReplacementNamed(context, '/home');
    }).catchError((err) {
      setState(() {
        _errorMessage = 'Verifique seu email ou senha e tente novamente.';
      });
    });
  }

  Future _verifyUserIsLogged() async {
    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = auth.currentUser;

    if (loggedUser != null) {

      Navigator.pushReplacementNamed(context, '/home');

    }
  }

  @override
  initState() {
    super.initState();
    _verifyUserIsLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff075E54)),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset('assets/images/logo.png',
                      width: 200, height: 150),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                        controller: _controllerEmail,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'E-mail',
                        ))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                        controller: _controllerPassword,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Senha',
                        ))),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    onPressed: () {
                      _validateFields();
                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    child: const Text(
                      'Não tem conta? Cadastre-se!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
