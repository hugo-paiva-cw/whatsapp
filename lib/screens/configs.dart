import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Configs extends StatefulWidget {
  const Configs({Key? key}) : super(key: key);

  @override
  State<Configs> createState() => _ConfigsState();
}

class _ConfigsState extends State<Configs> {
  final TextEditingController _controllerName = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future _getImage(String imageOrigin) async {

    XFile? selectedImage;
    switch( imageOrigin ) {
      case 'camera':
        selectedImage = await _picker.pickImage(source: ImageSource.camera);
        break;
      case 'galeria':
        selectedImage = await _picker.pickImage(source: ImageSource.gallery);
        break;
    }

    File? image = File(selectedImage!.path);
    setState(() {
      _image = image;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracoes'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/whatsapp-1ce1a.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=329c38db-7750-49f0-968d-818cd253c79f'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: () {
                          _getImage('camera');
                        },
                        child: Text('Camera')
                    ),
                    FlatButton(
                        onPressed: () {
                          _getImage('galeria');
                        },
                        child: Text('Galeria')
                    ),
                  ],
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
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    onPressed: () {

                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
