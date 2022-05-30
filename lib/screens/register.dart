import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/the_user.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // Controllers
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = '';

  _validateFields() {
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if ( name.isNotEmpty ) {

      if ( email.isNotEmpty && email.contains('@') ) {

        if ( password.length >= 6 ) {

          setState(() {
            _errorMessage = '';
          });

          TheUser user = TheUser();
          user.name = name;
          user.email = email;
          user.password = password;

          _registerUser(user);

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

    } else {
      setState(() {
        _errorMessage = 'Preencha o nome.';
      });
    }

  }

  _registerUser(TheUser user) async {

    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(email: user.email, password: user.password)
    .then((value) {
      print('User ${value.user!.email} cadastrado com sucesso!');
      setState(() {
        _errorMessage = 'Usuário cadastrado com sucesso!';
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()));
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection('users')
      .doc(auth.currentUser!.uid)
      .set(user.toMap());
    })
    .catchError((err) {
      print('O erro do app foi $err');
      setState(() {
        _errorMessage = 'Deu erro!';
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: const Color(0xff075E54),
      ),
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
                  child: Image.asset('assets/images/usuario.png',
                      width: 200, height: 150),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerName,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Nome',
                        ))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerEmail,
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
                      controller: _controllerPassword,
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
                    onPressed: () {
                      _validateFields();
                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
