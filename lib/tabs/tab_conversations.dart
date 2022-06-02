import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/the_user.dart';

class Conversations extends StatefulWidget {
  const Conversations({Key? key}) : super(key: key);

  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String _idLoggedUser;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Stream<QuerySnapshot>? _addConversationListener() {
    final stream = db
        .collection('conversations')
        .doc(_idLoggedUser)
        .collection('last_conversation')
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  _getUserData() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser!;
    _idLoggedUser = loggedUser.uid;

    _addConversationListener();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: const [
                    Text('Carregando mensagens'),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Text('Erro ao carregar os dados!');
              } else {
                QuerySnapshot? querySnapshot = snapshot.data;

                if (querySnapshot?.docs.length == 0) {
                  return const Center(
                    child: Text(
                      'Você nao tem nennuma mensagem ainda :(',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: querySnapshot!.docs.length,
                    itemBuilder: (context, index) {
                      List<DocumentSnapshot> conversations =
                          querySnapshot.docs.toList();
                      DocumentSnapshot item = conversations[index];

                      String imageUrl = item['pathPhoto'];
                      String type = item['messageType'];
                      String message = item['message'];
                      String name = item['name'];
                      String idReceipt = item['idReceipt'];

                      TheUser user = TheUser();
                      user.name = name;
                      user.imageUrl = imageUrl;
                      user.idUser = idReceipt;

                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/messages',
                              arguments: user);
                        },
                        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        leading: CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              imageUrl != null ? NetworkImage(imageUrl) : null,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          type == 'text' ? message : 'Imagem...',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      );
                    });
              }
          }
        });
  }
}
