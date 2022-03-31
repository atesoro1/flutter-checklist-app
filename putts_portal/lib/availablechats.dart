import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:putts_portal/person.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import '../logout.dart';

class AvailableChats extends StatefulWidget {
  const AvailableChats({Key? key}) : super(key: key);

  @override
  _AvailableChatsState createState() => _AvailableChatsState();
}

class _AvailableChatsState extends State<AvailableChats> {

  @override
  void didChangeDependencies(){
    chattersAvailable = getChatters(context);
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    try {
      sb!.close();
    } catch(e) {
    }
    super.dispose();
  }

  Future<List<Person>>? chattersAvailable;
  Map? args;
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: chattersAvailable,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.black,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitDancingSquare(
                          color: Colors.white,
                        ),
                        Text(
                          'Loading...',
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: MediaQuery.of(context).size.width * 0.02
                          ),
                        ),
                      ],
                    )
                ),
              ));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            List<Person> chatters = snapshot.data;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black87,
                  title: Text("CHATTERS"),
                ),
                body: Container(
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
                    children: [
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: chatters.length,
                              itemBuilder: (context, index){
                                return Container(
                                  margin: EdgeInsets.all(1),
                                  color: Colors.white24,
                                  child: ListTile(
                                    title: Text("${chatters[index].first} ${chatters[index].last}"),
                                    onTap: () => {
                                      createInstance(chatters[index].userId, context).then((value) => {
                                        if(value == 'successful'){
                                          Navigator.of(context).pop()
                                        } else if(value == 'exists'){
                                          sb = ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Already chatting with them!'),
                                              action: SnackBarAction(
                                                label: 'Okay',
                                                onPressed: () {
                                                  // Code to execute.
                                                },
                                              ),
                                            ),
                                          ),
                                        } else {
                                          sb = ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Could not create chat instance'),
                                              action: SnackBarAction(
                                                label: 'Okay',
                                                onPressed: () {
                                                  // Code to execute.
                                                },
                                              ),
                                            ),
                                          ),
                                        }
                                      })},
                                  ),
                                );
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  Future<List<Person>> getChatters(BuildContext context) async {
    try {
      args = ModalRoute.of(context)!.settings.arguments as Map;
      List<String> list = [];
      String people = '';
      List<Person>? chatters;
      args!.forEach((key, value) {
        if(key == 'chatters'){
          chatters = value as List<Person>;
          for(int x = 0; x < chatters!.length; x++){
            if(x == chatters!.length - 1){
              people += '{"first": "${chatters![x].first}", ';
              people += '"last": "${chatters![x].last}", ';
              people += '"id": "${chatters![x].userId}"}';
            } else {
              people += '{"first": "${chatters![x].first}", ';
              people += '"last": "${chatters![x].last}", ';
              people += '"id": "${chatters![x].userId}"},';
            }
          }
        }
        list.add('{"length": "${chatters!.length}", "${key}": [${people}]}');
      });
      final storage = await SharedPreferences.getInstance();
      storage.setStringList('page_state_arguments', list);
      return args!['chatters'] as List<Person>;
    } catch(e){
      final storage = await SharedPreferences.getInstance();
      List<Person> people = [];
      List<String> list = storage.getStringList('page_state_arguments')!;
      if(list.length != 0){
        var temp = await jsonDecode(list[0]);
        for(int x = 0; x < int.parse(temp['length']); x++){
          people.add(new Person(first: temp['chatters'][x]['first'], last: temp['chatters'][x]['last'], userId: int.parse(temp['chatters'][x]['id'])));
        }
      }
      return people;
    }
  }
  Future<String> createInstance(int receiverId, BuildContext context) async {
    String? responseBody;
    Response? responses;

    String users = "";
    List<int> ids = [];
    ids.add(Login.userId!);
    ids.add(receiverId);
    ids.sort();
    for(var x = 0; x < ids.length; x++){
      users += ids[x].toString();
      if(x != ids.length - 1){
        users += ", ";
      }
    }

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/chat/create/instance/');
    try {
      await HttpClientHelper.post(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {"users": users, "userId": Login.userId.toString()}).then((Response? response) => {
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
      return 'error';
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
    return json['status'];
  }
}



