import 'package:flutter/material.dart';
import 'package:whatsapp/screens/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'E-mail',
                        ))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Senha',
                        ))),
                Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    ),
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: const Text(
                        'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                    },
                    child: Text(
                      'Não tem conta? Cadastre-se!',
                      style: TextStyle(
                        color: Colors.white
                      ),
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
