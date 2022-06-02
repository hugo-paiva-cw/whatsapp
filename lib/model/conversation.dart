import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {

  late String _idSender;
  late String _idReceipt;
  late String _name;
  late String _message;
  late String _pathPhoto;
  late String _messageType; // text or image

  Conversation();

  save() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('conversations')
    .doc( idSender )
    .collection( 'last_conversation' )
    .doc( idReceipt )
    .set(toMap());
  }


  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'idSender' : _idSender,
      'idReceipt' : _idReceipt,
      'name' : _name,
      'message' : _message,
      'pathPhoto' : _pathPhoto,
      'messageType' : _messageType
    };
    return map;
  }

  String get idSender => _idSender;

  set idSender(String value) {
    _idSender = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get message => _message;

  String get pathPhoto => _pathPhoto;

  set pathPhoto(String value) {
    _pathPhoto = value;
  }

  set message(String value) {
    _message = value;
  }

  String get idReceipt => _idReceipt;

  String get messageType => _messageType;

  set messageType(String value) {
    _messageType = value;
  }

  set idReceipt(String value) {
    _idReceipt = value;
  }
}