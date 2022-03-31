import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import './login.dart';
import './main.dart';
import 'alert.dart';
import 'logout.dart';



class AlertNotification extends StatefulWidget {
  const AlertNotification({Key? key}) : super(key: key);

  @override
  _AlertNotificationState createState() => _AlertNotificationState();
}

class _AlertNotificationState extends State<AlertNotification> {

  @override
  void initState(){
    onNotificationReceived = (notification) async {
      refreshed = false;
      setState(() {
      });
    };
    MyApp.socket!.on('serverNotification', onNotificationReceived!);
    super.initState();
  }

  @override
  void dispose(){
    try {
      MyApp.socket!.off('serverNotification', onNotificationReceived);
      sb!.close();
    } catch(e) {
    }
    super.dispose();
  }

  void refresh() {
    setState(() {
    });
  }

  List notifications = [];
  bool refreshed = false;
  EventHandler? onNotificationReceived;
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    ZoomDrawer.of(context)!.close();

    getNotifications(context).then((value) => {
      notifications = value,
      if(refreshed == false){
        refreshed = true,
        refresh(),
      },
    });

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text('NOTIFICATIONS'),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                ZoomDrawer.of(context)!.toggle();
              },
            ),
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.black87,
                        ),
                        child: TextButton(
                          child: Text('clear', style: TextStyle(color: Colors.amber)),
                          onPressed: (){
                            deleteAllNotifications(context).then((value){
                              if(value == 'successful'){
                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Successfully deleted all notifications!'),
                                    action: SnackBarAction(
                                      label: 'okay',
                                      onPressed: () {
                                        // Code to execute.
                                      },
                                    ),
                                  ),
                                );
                                refreshed = false;
                                refresh();
                              } else if(value == 'exists'){
                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('You have no notifications to delete!'),
                                    action: SnackBarAction(
                                      label: 'okay',
                                      onPressed: () {
                                        // Code to execute.
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Could not delete all notifications!'),
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
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                notifications.length == 0 ? Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.2),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Text('NO NOTIFICATIONS', style: TextStyle(color: Colors.white)),
                  ),
                ) : Expanded(
                  child: Container(
                    child: ListView.builder(
                        itemCount: notifications.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          Alert notification = notifications[index] as Alert;
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.5),
                                    Colors.black.withOpacity(0.2),
                                  ],
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomEnd,
                                ),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ListTile(
                                leading: Text(notification.type, style: TextStyle(color: Colors.white)),
                                title: Text(notification.message, style: TextStyle(color: Colors.white)),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.amber),
                                  onPressed: () {
                                    deleteNotification(context, notification.notificationId).then((value){
                                      if(value == 'successful'){
                                        sb = ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Successfully deleted notification!'),
                                            action: SnackBarAction(
                                              label: 'okay',
                                              onPressed: () {
                                                // Code to execute.
                                              },
                                            ),
                                          ),
                                        );
                                        refreshed = false;
                                        refresh();
                                      } else {
                                        sb = ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Could not delete notification...'),
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
                                  }
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Future<List> getNotifications(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List temp = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/notifications/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'userId': Login.userId.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    List notifications = json['notifications'];
    for(var x = 0; x < notifications.length; x++){
      temp.add(new Alert(notificationId: notifications[x]['notificationId'], type: notifications[x]['notificationType'], message: notifications[x]['notificationMessage']));
    }

    return temp;
  }

  Future<String> deleteNotification(BuildContext context, int notificationId) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/notifications/delete');
    try {
      await HttpClientHelper.delete(url, timeLimit: Duration(seconds: 5), headers: {'userId': Login.userId.toString(), 'sessionId': Login.sessionId!, 'notificationId': notificationId.toString()}).then((Response? response) => {
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

  Future<String> deleteAllNotifications(BuildContext context) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/notifications/delete/all');
    try {
      await HttpClientHelper.delete(url, timeLimit: Duration(seconds: 5), headers: {'userId': Login.userId.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
