import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import '../logout.dart';
import '../main.dart';
import 'assignment.dart';
import 'listinstance.dart';
import '../login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';


class NonAdminList extends StatefulWidget {
  NonAdminList({Key? key}) : super(key: key);

  @override
  _NonAdminListState createState() => _NonAdminListState();
}

class _NonAdminListState extends State<NonAdminList> {

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

  BuildContext? instanceCtx;
  TextEditingController tc = new TextEditingController();
  late BuildContext itemsContext;
  VoidCallback? exit;
  VoidCallback? submit;
  String tempType= '';
  TimeOfDay? tempTime;
  DateTime? deadline;
  EventHandler? onNotificationReceived;
  bool refreshed = false;
  List<ListInstance> instances = [];
  List assignments = [];
  bool setController = false;
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  ScaffoldFeatureController? sb;


  @override
  Widget build(BuildContext context) {

    showInstances(context).then((value) => {
        instances = value,
        getAssignments(context).then((value) => {
          assignments = value,
          if(refreshed == false){
            refreshed = true,
            refresh()
          },
        }),
      });

    ZoomDrawer.of(context)!.close();

        return Scaffold(
          body: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(context),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: Colors.black87, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            navBarHeight: MediaQuery.of(context).size.height * .10,
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.easeInBack,
              duration: Duration(milliseconds: 500),
            ),
            navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
          ),
        );
  }

  Future<List<ListInstance>> showInstances(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List<ListInstance> _instances = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/instances/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'userId': Login.userId.toString(), 'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    List jsonList = json;


    for(int x = 0; x < jsonList.length; x++){
      _instances.add(new ListInstance(name: jsonList[x]['templateName'], instanceId: jsonList[x]['instanceId'], deadline: DateTime.parse(jsonList[x]['deadline']),));
    }

    return _instances;
  }
  List<Widget> _buildScreens(BuildContext context) {

    final ctx = context;

    return [
      Container(
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
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                  ZoomDrawer.of(context)!.toggle();
                },
              ),
              backgroundColor: Colors.black87,
              title: Text("LISTS"),
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
                  SizedBox(height: 20,),
                  Expanded(
                    flex: 15,
                    child: SizedBox(
                      child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            instanceCtx = context;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: instances.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(20),
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
                                        ),
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pushNamed(ctx, '/instance', arguments: {'instanceId': instances[index].instanceId}).then((value) => {
                                              refreshed = false,
                                              refresh(),
                                            });
                                          },
                                          leading: Icon(Icons.pan_tool, color: Colors.white),
                                          title: Text(
                                            instances[index].name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          trailing: Text(
                                            instances[index].deadline!.year == 0 ? "No Deadline" : instances[index].deadline!.toLocal().toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                        ),
                                      ),
                                      SizedBox(height: 20,)
                                    ],
                                  );
                                }
                            );
                          }
                      ),
                      height: MediaQuery.of(context).size.height * 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      SafeArea(
        child: Container(
          color: Colors.lightBlueAccent,
          child: Column(
            children: [
              Expanded(flex: 1, child: Text('Assignments')),
              Expanded(
                flex: 12,
                child: ListView.builder(
                    itemCount: assignments.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index){
                      Assignment assignment = assignments[index] as Assignment;
                      return ListTile(
                        title: Text(assignment.description!),
                        trailing: TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState){
                                      return AlertDialog(
                                        title: Text('Finish'),
                                        content: Container(
                                          alignment: Alignment.center,
                                          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3, maxHeight: MediaQuery.of(context).size.height * 0.3, minWidth: MediaQuery.of(context).size.width * 0.8, maxWidth: MediaQuery.of(context).size.width * 0.8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: assignment.tc,
                                                  maxLines: 8,
                                                  decoration: InputDecoration.collapsed(hintText: "Add Comment"),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                        "Exit"
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: (){
                                                        if(assignment.tc!.text.isEmpty){
                                                          sb = ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: const Text('Please enter a comment!'),
                                                              action: SnackBarAction(
                                                                label: 'okay',
                                                                onPressed: () {
                                                                  // Code to execute.
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          submitAssignment(assignment.assignmentId, assignment.tc!.text, context).then((value) {
                                                            if(value == 'successful'){
                                                              refreshed = false;
                                                              refresh();
                                                              Navigator.of(context).pop();
                                                            } else {
                                                              Navigator.of(context).pop();
                                                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: const Text('Could not submit assignment!'),
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
                                                    },
                                                    child: Text(
                                                        "Submit"
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                );
                              },
                              animationType: DialogTransitionType.size,
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                          child: Text('Finish'),
                        ),
                      );
                    }
                ),
              ),
            ],
          )
        ),
      ),
    ];
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {

    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.square_list),
        title: ("Lists"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.assignment_ind),
        title: ("Assignments"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
    ];
  }
  Future<List> getAssignments(BuildContext context) async {
    String? responseBody;
    Response? responses;
    List assignments = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/assignments/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'userId': Login.userId.toString(), 'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    List jsonList = json;


    for(int x = 0; x < jsonList.length; x++){
      assignments.add(new Assignment(assignmentId: jsonList[x]['assignmentId'], description: jsonList[x]['description'], tc: new TextEditingController()));
    }

    return assignments;
  }
  Future<String> submitAssignment(int? assignmentId, String? comment, BuildContext context) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/assignments/submit/');
    try {
      await HttpClientHelper.put(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'assignmentId': assignmentId.toString(), 'comment': comment, 'timeCompleted': DateTime.now().toString()}).then((Response? response) => {
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


