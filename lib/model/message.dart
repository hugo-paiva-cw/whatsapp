class Message {
  late String _idUser;
  late String _message;
  late String _urlImage;

  late String _type; // Defines message type to be image or text
  late String _date;

  set date(String value) {
    _date = value;
  }

  Message();

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'idUser': _idUser,
      'urlImage': _urlImage,
      'message': _message,
      'type': _type,
      'date': _date,
    };

    return map;
  }

  String get date => _date;

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get urlImage => _urlImage;

  set urlImage(String value) {
    _urlImage = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }
}