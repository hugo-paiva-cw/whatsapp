import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/tabs/tab_contacts.dart';
import '../tabs/tab_conversations.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> itemsMenu = [
    'Configuracoes', 'Deslogar'
  ];

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  _chooseMenuItem(String itemChose) {

    switch( itemChose ) {
      case 'Configuracoes':
        Navigator.pushNamed(context, '/configs');
        // ver pq pushNamed nao funciona aqui
        break;
      case 'Deslogar':
        _unlogUser();
        break;
    }
    
  }

  _unlogUser() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, '/login');

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
        actions: [
          PopupMenuButton<String>(
            onSelected: _chooseMenuItem,
            itemBuilder: (context) {
              return itemsMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [Conversations(), Contacts()],
      ),
    );
  }
}
