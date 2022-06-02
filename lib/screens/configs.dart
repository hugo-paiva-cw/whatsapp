import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class Configs extends StatefulWidget {
  const Configs({Key? key}) : super(key: key);

  @override
  State<Configs> createState() => _ConfigsState();
}

class _ConfigsState extends State<Configs> {
  final TextEditingController _controllerName = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late File _image;
  late String _idLoggedUser;
  bool _uploadingImage = false;
  String? _retrievedImageUrl;

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

    File image = File(selectedImage!.path);
    setState(() {
      _image = image;
      if ( _image != null) {
        _uploadingImage = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    await Firebase.initializeApp();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootFolder = storage.ref();
    Reference file = rootFolder
        .child('profile')
        .child('$_idLoggedUser.jpg');

    UploadTask task = file.putFile(_image);

    task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.running) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (taskSnapshot.state == TaskState.success) {
        _retrieveUrl(taskSnapshot);
        setState(() {
          _uploadingImage = false;
        });
      }
    });
  }

  Future _retrieveUrl(TaskSnapshot taskSnapshot) async {
    var url = await taskSnapshot.ref.getDownloadURL();
    _updateImageUrlFirestore( url );

    setState(() {
      _retrievedImageUrl = url;
    });
  }

  _updateImageUrlFirestore(String url) async {
    await Firebase.initializeApp();

    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dataUpdate = {
      'imageUrl': url
    };

    db.collection('users')
    .doc(_idLoggedUser)
    .update(dataUpdate);
  }

  _updateNameFirestore() async {
    await Firebase.initializeApp();

    String name = _controllerName.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dataUpdate = {
      'name': name
    };

    db.collection('users')
        .doc(_idLoggedUser)
        .update(dataUpdate);
  }

  _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser!;
    _idLoggedUser = loggedUser.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection('users')
    .doc(_idLoggedUser)
    .get();

    var data = jsonEncode(snapshot.data());
    Map<String, dynamic>? valueMap = jsonDecode(data);
    _controllerName.text = valueMap!['name'];

    if ( valueMap['imageUrl'] != null ) {
      setState(() {
        _retrievedImageUrl = valueMap['imageUrl'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracoes'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: _uploadingImage
                      ? const CircularProgressIndicator()
                      : Container(),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      _retrievedImageUrl != null
                    ? NetworkImage(_retrievedImageUrl!)
                  : null
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: () {
                          _getImage('camera');
                        },
                        child: const Text('Camera')
                    ),
                    FlatButton(
                        onPressed: () {
                          _getImage('galeria');
                        },
                        child: const Text('Galeria')
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
                      _updateNameFirestore();
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
