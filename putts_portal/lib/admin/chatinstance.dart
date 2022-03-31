import 'package:putts_portal/person.dart';

class ChatInstance {

  ChatInstance({required this.title, required this.chatInstanceId, required this.users, required this.currentMessage});

  String? title;
  int? chatInstanceId;
  List<Person>? users;
  String? currentMessage;
}