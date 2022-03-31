import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:putts_portal/person.dart';
import 'package:putts_portal/non-admin/chatinstance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';
import '../logout.dart';
import '../main.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';

class People extends StatefulWidget {
  const People({Key? key, first, userId, last}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {

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

  bool refreshed = false;
  ScaffoldFeatureController? sb;
  List<Person> people = [];
  List<Person> chatters = [];
  List<ChatInstance> chatInstances = [];
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  EventHandler? onMessageReceived;

  @override
  Widget build(BuildContext context) {


    create().then((value) async => {
      await getChatInstances().then((value) => {
        chatInstances = value,
      }),
      people = value[0],
      chatters = value[1],
      if(refreshed == false){
        refreshed = true,
        refresh()
      },
    });

    ZoomDrawer.of(context)!.close();

    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

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

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.people),
        title: ("People"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.message),
        title: ("Messages"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
    ];
  }
  List<Widget> _buildScreens(BuildContext context) {

    final ctx = context;

    return [
      SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                ZoomDrawer.of(context)!.toggle();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            ),
            title: Text("EMPLOYEES"),
            backgroundColor: Colors.black87,
          ),
          resizeToAvoidBottomInset: false,
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
                people.isEmpty ? Container(child: Text('No one')) : Expanded(
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: people.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
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
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: AssetImage('assets/shiba.jpg'),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${people[index].first}',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${people[index].last}',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("MESSAGES"),
            backgroundColor: Colors.black87,
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(ctx, '/availableChats', arguments: {'chatters': chatters}).then((value) => {
                    refreshed = false,
                    setState((){})
                  });
                },
                icon: Icon(Icons.add, color: Colors.white),
              ),
            ],
            leading: IconButton(
              onPressed: () {
                ZoomDrawer.of(context)!.toggle();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
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
                chatInstances.length == 0 ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text('NO CHATS', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ): Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatInstances.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            InkWell(
                              overlayColor: MaterialStateProperty.all(Colors.yellow),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 100,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 14.0),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: AssetImage('assets/shiba.jpg'),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.35,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${chatInstances[index].title}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${chatInstances[index].currentMessage}',
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: (){
                                        deleteChatInstance(chatInstances[index].chatInstanceId!).then((value) => {
                                          if(value == 'successful'){
                                            refreshed = false,
                                            refresh(),
                                            sb = ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: const Text('Successfully deleted chat!'),
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
                                                content: const Text('Could not delete chat!'),
                                                action: SnackBarAction(
                                                  label: 'Okay',
                                                  onPressed: () {
                                                    // Code to execute.
                                                  },
                                                ),
                                              ),
                                            ),
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                String ids = "";
                                for(var x = 0; x < chatInstances[index].users!.length; x++){
                                  ids += chatInstances[index].users![x].userId.toString();
                                  if(x != chatInstances[index].users!.length - 1){
                                    ids += ", ";
                                  }
                                }
                                Navigator.pushNamed(ctx, '/message', arguments: {'chatInstanceId': chatInstances[index].chatInstanceId, 'users': ids, 'first': chatInstances[index].users![0].first}).then((value) => {
                                  refreshed = false,
                                  setState((){})
                                });
                              },
                            ),
                            SizedBox(height: 20,)
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];

  }
  Future<List<List<Person>>> create() async {
    String? responseBody;
    Response? responses;
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/people/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'location': Login.location!, 'sessionId': Login.sessionId!}).then((Response? response) => {
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
              storage.remove('loggingIn');
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
    List jsonList = json as List;
    List<List<Person>> temp = [];
    List<Person> everyone = [];
    List<Person> chatters = [];
    temp.insert(0, everyone);
    temp.insert(1, chatters);
    try {
      for(int x = 0; x < jsonList.length; x++){
        temp[0].add(new Person(userId: jsonList[x]['userId'], first: jsonList[x]['firstName'], last: jsonList[x]['lastName']));
        if(Login.userId != jsonList[x]['userId']){
          temp[1].add(new Person(userId: jsonList[x]['userId'], first: jsonList[x]['firstName'], last: jsonList[x]['lastName']));
        }
      }
    }catch(e){

    }

    return temp;
  }
  Future<String> getLastMessage(int chatInstanceId) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/chat/instances/lastMessage/');
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
      return 'N/A';
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
              storage.remove('loggingIn');
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
    return json['message'];
  }
  Future<List<ChatInstance>> getChatInstances() async {
    String? responseBody;
    Response? responses;

    List<ChatInstance> temp = [];
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/chat/instances/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {"userId": Login.userId.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
              storage.remove('loggingIn');
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
    var instances = json['response']['chatInstances'];
    try {
      for(var x = 0; x < instances.length; x++){
        List<Person> people = [];
        String title = "";
        for(var y = 0; y < instances[x]['users'].length; y++){
          people.add(new Person(first: instances[x]['users'][y]['first'], last: instances[x]['users'][y]['last'], userId: instances[x]['users'][y]['userId']));
          title += "${instances[x]['users'][y]['first']} ";
          title += "${instances[x]['users'][y]['last']}";
          if(y != instances[x]['users'].length - 1){
            title += ", ";
          }
        }
        String currentMessage = await getLastMessage(instances[x]['chatInstanceId']);
        temp.add(new ChatInstance(title: title, chatInstanceId: instances[x]['chatInstanceId'], users: people, currentMessage: currentMessage));
      }
    }catch(e){

    }

    return temp;
  }
  Future<String> deleteChatInstance(int id) async {
    String? responseBody;
    Response? responses;

    List<ChatInstance> temp = [];
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/chat/instance/delete');
    try {
      await HttpClientHelper.delete(url, timeLimit: Duration(seconds: 5), headers: {"chatInstanceId": id.toString(), 'userId': Login.userId.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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

              storage.remove('loggingIn');
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

