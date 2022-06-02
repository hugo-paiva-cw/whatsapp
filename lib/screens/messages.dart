import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/model/conversation.dart';
import 'dart:io';
import '../model/message.dart';
import '../model/the_user.dart';

class Messages extends StatefulWidget {
  final TheUser? contato;

  const Messages(this.contato, {Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late String _idLoggedUser;
  late String _idUserDestination;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _controllerMessage = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final ImagePicker _picker = ImagePicker();
  var _uploadingImage = false;
  final ScrollController _scrollController = ScrollController();

  _sendTextMessage() {
    String textMessage = _controllerMessage.text;
    if (textMessage.isNotEmpty) {
      Message message = Message();
      message.idUser = _idLoggedUser;
      message.message = textMessage;
      message.urlImage = '';
      message.date = Timestamp.now().toString();
      message.type = 'text';

      //save message for the sender
      _saveMessage(_idLoggedUser, _idUserDestination, message);

      //save message for the receiver
      _saveMessage(_idUserDestination, _idLoggedUser, message);

      //save conversation
      _saveConversation(message);
    }
  }

  _saveConversation(Message msg) {
    // save chat for sender
    Conversation cSender = Conversation();
    cSender.idReceipt = _idLoggedUser;
    cSender.idSender = _idUserDestination;
    cSender.message = msg.message;
    cSender.name = widget.contato!.name;
    cSender.pathPhoto = widget.contato?.imageUrl ?? '';
    cSender.messageType = msg.type;
    cSender.save();

    // save chat for receiver
    Conversation cReceipt = Conversation();
    cReceipt.idReceipt = _idUserDestination;
    cReceipt.idSender = _idLoggedUser;
    cReceipt.message = msg.message;
    cReceipt.name = widget.contato!.name;
    cReceipt.pathPhoto = widget.contato?.imageUrl ?? '';
    cReceipt.messageType = msg.type;
    cReceipt.save();
  }

  _saveMessage(String idSender, String idRecipient, Message msg) {
    db
        .collection('messages')
        .doc(idSender)
        .collection(idRecipient)
        .add(msg.toMap());

    _controllerMessage.clear();
  }

  _sendPhoto() async {
    XFile? selectedImage;
    selectedImage = await _picker.pickImage(source: ImageSource.gallery);

    File image = File(selectedImage!.path);

    _uploadingImage = true;
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootFolder = storage.ref();
    Reference file =
        rootFolder.child('messages').child(_idLoggedUser).child(imageName);

    UploadTask task = file.putFile(image);

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

    Message message = Message();
    message.idUser = _idLoggedUser;
    message.message = '';
    message.urlImage = url;
    message.date = Timestamp.now().toString();
    message.type = 'image';

    _saveMessage(_idLoggedUser, _idUserDestination, message);
    _saveMessage(_idUserDestination, _idLoggedUser, message);
  }

  _getUserData() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser!;
    _idLoggedUser = loggedUser.uid;
    _idUserDestination = widget.contato!.idUser;

    _addConversationListener();
  }


  Stream<QuerySnapshot>? _addConversationListener() {
    final stream = db.collection('messages')
        .doc( _idLoggedUser )
        .collection( _idUserDestination )
        .orderBy('date', descending: false)
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
      Timer(const Duration(seconds: 1), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var messageBox = Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextField(
                  controller: _controllerMessage,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    prefixIcon: _uploadingImage
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: _sendPhoto,
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Digite uma mensagem...',
                  )),
            ),
          ),
          Platform.isIOS
              ? CupertinoButton(
                  onPressed: _sendTextMessage,
                  child: const Text('Enviar'))
              : FloatingActionButton(
                  backgroundColor: const Color(0xff075E54),
                  mini: true,
                  onPressed: _sendTextMessage,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
        ],
      ),
    );

    var stream = StreamBuilder<QuerySnapshot>(
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
            QuerySnapshot? querySnapshot = snapshot.data;

            if (snapshot.hasError || querySnapshot == null) {
              return const Expanded(child: Text('Erro ao carregar dados!'));
            } else {
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> messages =
                        querySnapshot.docs.toList();
                    DocumentSnapshot item = messages[index];

                    double containerWidth =
                        MediaQuery.of(context).size.width * 0.8;

                    // define colors and alignments
                    Alignment alignment = Alignment.centerRight;
                    Color color = const Color(0xffd2ffa5);

                    if (_idLoggedUser != item['idUser']) {
                      alignment = Alignment.centerLeft;
                      color = Colors.white;
                    }

                    return Align(
                      alignment: alignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          width: containerWidth,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: item['type'] == 'text'
                              ? Text(
                                  item['message'],
                                  style: const TextStyle(fontSize: 18),
                                )
                              : Image.network(item['urlImage']),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contato?.imageUrl != null
                    ? NetworkImage(widget.contato!.imageUrl)
                    : null),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(widget.contato!.name),
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                stream,
                messageBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
