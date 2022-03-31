import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:bubble/bubble.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import '../login.dart';
import '../logout.dart';
import '../main.dart';
import 'message.dart';

class MessageView extends StatefulWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {

  @override
  void initState(){
    onMessageReceived = (message) async {
      refreshed = false;
      setState(() {
      });
    };
    MyApp.socket!.on('msg', onMessageReceived!);
    super.initState();
  }

  @override
  void dispose(){
    try {
      MyApp.socket!.off('msg', onMessageReceived);
      sb!.close();
    } catch(e) {
    }
    super.dispose();
  }

  void refresh() {
    setState(() {

    });
  }

  EventHandler? onMessageReceived;
  bool refreshed = false;
  List messages = [];
  TextEditingController textController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {


    final args = ModalRoute.of(context)!.settings.arguments as Map;

    getMessages(args['chatInstanceId']).then((value) => {
      messages = value,
      if(refreshed == false){
        refreshed = true,
        refresh()
      },
    });


    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.lightBlue,
                    Colors.green,
                    Colors.yellow,
                  ]
              )
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      args['first'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      Message message = messages[index] as Message;
                      return Bubble(
                          margin: BubbleEdges.only(top: 10, bottom: index == messages.length - 1 ? 40 : 0),
                          alignment: message.senderId == Login.userId ? Alignment.topRight : Alignment.topLeft,
                          nip: message.senderId == Login.userId ? BubbleNip.rightTop : BubbleNip.leftTop,
                          color: Color.fromRGBO(225, 255, 199, 1.0),
                          child: Text(message.text.toString(), textAlign: TextAlign.center,)
                      );
                    }
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                      ),
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(45)),
                        ),
                        child: IconButton(
                          highlightColor: Colors.lightBlue,
                          splashColor: Colors.green,
                          hoverColor: Colors.yellow,
                          color: Colors.black,
                          icon: Icon(
                            Icons.label_important,
                          ),
                          onPressed: () async {
                            if(textController.text != ''){
                              await insertMessage(args['chatInstanceId'], textController.text, Login.userId!, args['users']);
                              refreshed = false;
                              MyApp.socket!.emit('message', {'text': textController.text, 'senderId': Login.userId, 'receiverId': args['users']});
                              MyApp.socket!.emit('clientNotification', {'type': 'message', 'message': 'Received a message from ', 'senderId': Login.userId, 'receiverId': args['users']});
                              textController.text = '';
                              setState(() {
                              });
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent + 200,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                            }
                          },
                        ),

                      )
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> getMessages(int chatInstanceId) async {
    String? responseBody;
    Response? responses;

    List temp = [];
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/chat/messages/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'chatInstanceId': chatInstanceId.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
        responseBody = response!.body,
        responses = response
      });
    } catch(e){
      sb = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not connect to server!'),
          action: SnackBarAction(
            label: 'okay',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
      return [];
    }
    var json = await jsonDecode(responseBody!);
    try{
      if(json['status'] == 'no-session'){
        sb = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid Session, logging out...'),
            action: SnackBarAction(
              label: 'okay',
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );
        Timer(Duration(seconds: 3), () {
          Logout.logout().then((value) async {
            if(value == 'successful'){
              final storage = await SharedPreferences.getInstance();
              storage.remove('login');
              storage.remove('sessionId');
              storage.remove('userId');
              storage.remove('admin');
              storage.remove('userPermissions');
              storage.remove('jobPermissions');
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            } else {
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Could not log you out...'),
                  action: SnackBarAction(
                    label: 'okay',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            }
          });
        });
      }
    } catch (e){
      //replaced
    }

    try {
      for(int x = 0; x < json['chatMessages'].length; x++){
        temp.add(new Message(json['chatMessages'][x]['chatMessage'], json['chatMessages'][x]['senderId'], json['chatMessages'][x]['receiverId']));
      }
    }catch(e){

    }
    return temp;
  }
  Future<void> insertMessage(int chatInstanceId, String text, int senderId, String receiverId) async {
    String? responseBody;
    Response? responses;


    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/chat/messages/insert/');
    try {
      await HttpClientHelper.post(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'chatInstanceId': chatInstanceId.toString(), 'text': text, 'senderId': senderId.toString(), 'receiverId': receiverId.toString()}).then((Response? response) => {
        responseBody = response!.body,
        responses = response
      });
    } catch(e){
      sb = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not connect to server!'),
          action: SnackBarAction(
            label: 'okay',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
    var json = await jsonDecode(responseBody!);
    try{
      if(json['status'] == 'no-session'){
        sb = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid Session, logging out...'),
            action: SnackBarAction(
              label: 'okay',
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );
        Timer(Duration(seconds: 3), () {
          Logout.logout().then((value) async {
            if(value == 'successful'){
              final storage = await SharedPreferences.getInstance();
              storage.remove('login');
              storage.remove('sessionId');
              storage.remove('userId');
              storage.remove('admin');
              storage.remove('userPermissions');
              storage.remove('jobPermissions');
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            } else {
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Could not log you out...'),
                  action: SnackBarAction(
                    label: 'okay',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            }
          });
        });
      }
    } catch (e){
      //replaced
    }
  }
}
