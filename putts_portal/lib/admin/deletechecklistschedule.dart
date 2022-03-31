import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import '../logout.dart';
import 'schedule.dart';
import '../main.dart';

class DeleteChecklistSchedule extends StatefulWidget {
  const DeleteChecklistSchedule({Key? key}) : super(key: key);

  @override
  _DeleteChecklistScheduleState createState() => _DeleteChecklistScheduleState();
}

class _DeleteChecklistScheduleState extends State<DeleteChecklistSchedule> {

  @override
  void initState(){
    onNotificationReceived = (notification) async {
      setState(() {});
    };
    MyApp.socket!.on('serverNotification', onNotificationReceived!);
    super.initState();
  }

  @override
  void didChangeDependencies(){
    Future.delayed(Duration(milliseconds: 750)).then((value){
      if(mounted){
        setState(() {
          retrievedSchedules = getSchedules(context);
        });
      }
    });
    super.didChangeDependencies();
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

  Future<List<Schedule>>? retrievedSchedules;
  EventHandler? onNotificationReceived;
  bool refreshed = false;
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('DELETE SCHEDULE'),
          backgroundColor: Colors.black87,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
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
          child: FutureBuilder(
            future: retrievedSchedules,
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
                  List<Schedule> schedules = snapshot.data as List<Schedule>;
                  return Column(
                    children: [
                      schedules.length == 0 ? Expanded(
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              width: 1.5,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.9,
                          width: MediaQuery.of(context).size.width * 0.95,
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(10),
                          child: Text('NO SCHEDULES', style: TextStyle(color: Colors.white)),
                        ),
                      ) : Expanded(
                        child: Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: schedules.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1),
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.black.withOpacity(0.2),
                                      ],
                                      begin: AlignmentDirectional.topStart,
                                      end: AlignmentDirectional.bottomEnd,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(schedules[index].scheduleName!, style: TextStyle(color: Colors.white)),
                                    trailing: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.amber),
                                        onPressed: (){
                                          deleteSchedule(context, schedules[index].scheduleName!).then((value) async {
                                            if(value == 'successful'){
                                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text('Successfully deleted schedule!'),
                                                  action: SnackBarAction(
                                                    label: 'okay',
                                                    onPressed: () {
                                                      // Code to execute.
                                                    },
                                                  ),
                                                ),
                                              );
                                              setState(() {
                                                retrievedSchedules = getSchedules(context);
                                              });
                                            } else if(value == 'exists'){
                                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text('That schedule does not exist anymore!'),
                                                  action: SnackBarAction(
                                                    label: 'okay',
                                                    onPressed: () {
                                                      // Code to execute.
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else if(value == 'network'){
                                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text('Did not delete schedule, not on the network!'),
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
                                                  content: const Text('Could not delete schedule!'),
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
                                );
                              }
                          ),
                        ),
                      ),
                    ],
                  );;
                } else {
                  return const Text('Empty data');
                }
              } else {
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
              }
            }
          )
        ),
    );
  }

  Future<List<Schedule>> getSchedules(BuildContext context) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/schedule/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    List<Schedule> temp = [];
    if(json['status'] == 'successful'){
      for(int x = 0; x < (json['schedules'] as List).length; x++){
        temp.add(new Schedule(dateRangeEnd: json['schedules'][x]['dateRangeEnd'].toString(), dateRangeStart: json['schedules'][x]['dateRangeStart'].toString(), recurring: json['schedules'][x]['recurring'], scheduleName: json['schedules'][x]['scheduleName']));
      }
    } else if(json['status'] == 'network'){
      sb = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Not on the network!'),
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
          content: const Text('Could not retrieve schedules!'),
          action: SnackBarAction(
            label: 'okay',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
    return temp;
  }
  Future<String> deleteSchedule(BuildContext context, String scheduleName) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/schedule/delete?schedule=' + scheduleName);
    try {
      await HttpClientHelper.delete(url, timeLimit: Duration(seconds: 5), headers: {'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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

