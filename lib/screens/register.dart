import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // Controllers
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = '';

/**/
  _validateFields() {
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if ( name.isNotEmpty ) {

      if ( email.isNotEmpty && email.contains('@') ) {

        if ( password.isNotEmpty ) {

          setState(() {
            _errorMessage = '';
          });

          _registerUser();

        } else {
          setState(() {
            _errorMessage = 'Preencha a senha.';
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

  _registerUser() {

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
