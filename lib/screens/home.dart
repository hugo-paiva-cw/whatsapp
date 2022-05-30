import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/tabs/tab_contacts.dart';
import '../tabs/tab_conversations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp'),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Conversas',
            ),
            Tab(
              text: 'Contatos',
            ),
          ],
        ),
      ),
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: const [Conversations(), Contacts()],
        ),
      ),
    );
  }
}
