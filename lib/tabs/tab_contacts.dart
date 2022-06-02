import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/the_user.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String? _idLoggedUser;
  String? _emailLoggedUser;

  Future<List<TheUser>> _getContacts() async {
    Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db.collection('users').get();

    List<TheUser> usersList = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      var data = jsonEncode(item.data());
      Map<String, dynamic> valueData = jsonDecode(data);

      if (valueData['email'] == _emailLoggedUser) continue;

      TheUser user = TheUser();
      user.idUser = item.id;
      user.email = valueData['email'];
      user.name = valueData['name'];
      user.imageUrl = valueData['imageUrl'];

      usersList.add(user);
    }

    return usersList;
  }

  _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser!;
    _idLoggedUser = loggedUser.uid;
    _emailLoggedUser = loggedUser.email;
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TheUser>>(
      future: _getContacts(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: const [
                  Text('Carregando contatos'),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  List<TheUser> itemsList = snapshot.data!;
                  TheUser user = itemsList[index];

                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/messages',
                          arguments: user);
                    },
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: user.imageUrl != null
                            ? NetworkImage(user.imageUrl)
                            : null),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                });
        }
      },
    );
  }
}
