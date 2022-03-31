import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';


class Logout extends StatefulWidget {
  const Logout({Key? key}) : super(key: key);

  static Future<String> logout() async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/account/logout/');
    try {
      await HttpClientHelper.put(url, timeLimit: Duration(seconds: 5), headers: {'userId': Login.userId.toString(), 'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
        responseBody = response!.body,
        responses = response
      });
    } catch(e){
      return 'error';
    }
    var json = await jsonDecode(responseBody!);
    return json['status'];
  }
  static ScaffoldFeatureController? sb;

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  @override
  void dispose(){
    try {
      Logout.sb!.close();
    } catch(e) {
    }

    try {
      sb!.close();
    } catch(e) {
    }
    super.dispose();
  }

  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    ZoomDrawer.of(context)!.close();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              ZoomDrawer.of(context)!.toggle();
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
          backgroundColor: Colors.black87,
          title: Text('LOGOUT', style: TextStyle(color: Colors.white))
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
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(30),
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1,),
                width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.3, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.7), Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.9)]).value!,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(360)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('It\'s sad to see you go :( hit the logout button below to end your session', softWrap: true, style: TextStyle(color: Colors.white),),
                    TextButton(
                        child: Text('LOGOUT', style: TextStyle(color: Colors.amber)),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context){
                                return StatefulBuilder(
                                  builder: (BuildContext context, void Function(void Function()) setState) {
                                    return AlertDialog(
                                      backgroundColor: Colors.black45,
                                      content: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          border: Border.all(
                                            width: 1.5,
                                            color: Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width * 0.175,
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Are you sure you want to logout?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                    child: Text('NO', style: TextStyle(color: Colors.amber)),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }
                                                ),
                                                TextButton(
                                                  child: Text('YES', style: TextStyle(color: Colors.amber)),
                                                  onPressed: () {
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
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                          );
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}