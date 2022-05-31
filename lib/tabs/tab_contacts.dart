import 'package:flutter/material.dart';

import '../model/conversation.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Conversation> listOfConversations = [
    Conversation('Ana Clara', 'oie sumido',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1ce1a.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=329c38db-7750-49f0-968d-818cd253c79f'),
    Conversation('Pedro Silva', 'comprei aquele ssd novo',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1ce1a.appspot.com/o/profile%2Fperfil2.jpg?alt=media&token=c5133363-f454-4cd9-be74-aa6abd95a4dd'),
    Conversation('Marcela Almeida', 'foi na casa da Gabi',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1ce1a.appspot.com/o/profile%2Fperfil3.jpg?alt=media&token=3f1b7873-5d85-4446-a62c-0565b488d7d6'),
    Conversation('José Renato', 'iae',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1ce1a.appspot.com/o/profile%2Fperfil4.jpg?alt=media&token=149dcb21-cd9f-44cc-a110-b65e3044e183'),
    Conversation('Jamilton Damasceno', 'Curso novo vem aí',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1ce1a.appspo.com/o/profile%2Fperfil5.jpg?alt=media&token=81f2f481-3b23-4a15-a433-1d471a67e675'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listOfConversations.length,
        itemBuilder: (context, index) {
          Conversation conversation = listOfConversations[index];

          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(conversation.pathPhoto),
            ),
            title: Text(
              conversation.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        });
  }
}
