import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import '../login.dart';
import '../logout.dart';
import '../main.dart';
import '../menuitem.dart';

class AdminMenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const people = MenuItem('People', Icons.people_rounded);
  static const lists = MenuItem('Lists', Icons.list_alt);
  static const departments = MenuItem('Department', Icons.other_houses);
  static const notifications = MenuItem('Notifications', Icons.doorbell);
  static const logout = MenuItem('Logout', Icons.logout);
  static const all = <MenuItem> [
    home,
    people,
    lists,
    departments,
    notifications,
    logout,
  ];
}

class AdminMenu extends StatefulWidget {

  final MenuItem currentAdminMenuItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const AdminMenu({
    Key? key,
    required this.currentAdminMenuItem,
    required this.onSelectedItem,
  }) : super(key: key);

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {

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

  bool refreshed = false;
  int key = new Random().nextInt(10000);
  int count = 0;
  EventHandler? onNotificationReceived;
  ScaffoldFeatureController? sb;


  @override
  Widget build(BuildContext context) {

    getNotificationCount(context).then((value) => {
      count = value,
      if(refreshed == false){
        refreshed = true,
        refresh(),
      },
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black87,
                    Colors.yellow,
                    Colors.yellow,
                    Colors.yellow,
                  ]
              )
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 15,
                child: Container(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * .37),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black87,
                            Colors.green,
                            Colors.yellow,
                          ]
                      )
                  ),
                  //child: Image.asset('./assets/shiba.jpg', width: 200, height: 200),
                ),
              ),
              Spacer(),
              ...AdminMenuItems.all.map(buildAdminMenuItem).toList(),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );

  }

  Widget buildAdminMenuItem(MenuItem item) => item.name == 'Lists' ?
  Container(
    color: Colors.black87,
    child: ExpansionTile(
      key: new Key(key.toString()),
      leading: Icon(
        item.icon,
        color: Colors.amber,
      ),
      title: Text(
        item.name,
        style: TextStyle(
          // shadows: <Shadow>[
          //   Shadow(
          //     offset: Offset(1.0, 0),
          //     blurRadius: 10,
          //     color: Color.fromARGB(255, 40, 70, 100),
          //   ),
          // ],
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 2.5,
        ),
      ),
      children: [
        ListTile(
          selectedTileColor: Colors.yellow[400],
          selected: widget.currentAdminMenuItem == item,
          leading: Icon(
            item.icon,
            color: Colors.amber,
          ),
          title: Text(
            "List Home",
            style: TextStyle(
              // shadows: <Shadow>[
              //   Shadow(
              //     offset: Offset(1.0, 0),
              //     blurRadius: 10,
              //     color: Color.fromARGB(255, 40, 70, 100),
              //   ),
              // ],
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2.5,
            ),
          ),
          onTap: () => {
            setState(() {
              key = Random().nextInt(10000);
            }),
            widget.onSelectedItem(item),
          },
        ),
        ListTile(
          selectedTileColor: Colors.yellow[400],
          selected: widget.currentAdminMenuItem == item,
          leading: Icon(
            item.icon,
            color: Colors.amber,
          ),
          title: Text(
            "Barcodes",
            style: TextStyle(
              // shadows: <Shadow>[
              //   Shadow(
              //     offset: Offset(1.0, 0),
              //     blurRadius: 10,
              //     color: Color.fromARGB(255, 40, 70, 100),
              //   ),
              // ],
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2.5,
            ),
          ),
          onTap: () {
            setState(() {
              key = Random().nextInt(10000);
            });
            ZoomDrawer.of(context)!.close();
            Navigator.pushNamed(context, '/barcode');
          }
        ),
      ],
    ),
  )
  : Container(
    color: Colors.black87,
    child: ListTile(
      selectedTileColor: Colors.yellow[400],
      selected: widget.currentAdminMenuItem == item,
      leading: item.name != 'Notifications' ? Icon(
          item.icon,
          color: Colors.amber,
      ) : Container(margin: EdgeInsets.only(left: 5),child: Text('${count}', style: TextStyle(color: Colors.white),)),
      title: Text(
          item.name,
          style: TextStyle(
            // shadows: <Shadow>[
            //   Shadow(
            //     offset: Offset(1.0, 0),
            //     blurRadius: 10,
            //     color: Color.fromARGB(255, 40, 70, 100),
            //   ),
            // ],
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 2.5,
          ),
      ),
      onTap: () => widget.onSelectedItem(item),
    ),
  );

  Future<int> getNotificationCount(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List temp = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/notifications/count/');
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
      return 0;
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
    return json['count'];
  }
}
