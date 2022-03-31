import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:putts_portal/admin/reporting/checklistaverage.dart';
import 'package:putts_portal/admin/reporting/department.dart';
import 'package:putts_portal/admin/reporting/user.dart';
import 'package:putts_portal/admin/userpermission.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';
import '../logout.dart';
import '../main.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:putts_portal/admin/reporting/department.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import 'dart:html' as html;

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class NonAdminHomeWeb extends StatefulWidget {
  const NonAdminHomeWeb({Key? key}) : super(key: key);

  @override
  _NonAdminHomeWebState createState() => _NonAdminHomeWebState();
}

class _NonAdminHomeWebState extends State<NonAdminHomeWeb> {

  int complete = 0;
  int incomplete = 0;
  List checklists = [];
  List assignments = [];
  bool statusOk = false;
  EventHandler? onNotificationReceived;
  Future<Map>? data;

  Future<Map> getData(BuildContext context) async {
    String? responseBody;
    Response? responses;
    //replaced
    Map temp = new Map();
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/employee/dashboard/data/');
    try {
      await HttpClientHelper.get(url, retries: 3, timeRetry: Duration(milliseconds: 100), timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'location': Login.location!, 'sessionId': Login.sessionId!, 'userId': Login.userId.toString()}).then((Response? response) => {
        responseBody = response!.body,
        responses = response
      });
    } catch(e){
      temp['status'] = 'network';
      return temp;
    }
    var json = await jsonDecode(responseBody!);

    temp['status'] = json['status'];
    temp['complete'] = json['complete'];
    temp['incomplete'] = json['incomplete'];
    temp['checklists'] = json['checklists'];
    temp['assignments'] = json['assignments'];

    try{
      if(json['status'] == 'no-session'){
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
              temp['status'] = 'session-error-incomplete';
              return temp;
            }
          });
        });
        temp['status'] = 'session-error-complete';
        return temp;
      }
    } catch (e){
      //continue
    }
    return temp;
  }


  @override
  void initState() {
    html.window.onBeforeUnload.listen((event) {
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
        }
      });
    });
    super.initState();
  }

  Timer? timer;

  @override
  void didChangeDependencies(){
    if(!Navigator.of(context).canPop()){
      data = getData(context);
    } else {
      timer = Timer.periodic(Duration(seconds: 2), (time) {
        if(!Navigator.of(context).canPop()){
          data = getData(context);
          setState((){});
          timer!.cancel();
        }
      });
    }
    onNotificationReceived = (notification) async {
      if(!Navigator.of(context).canPop()){
        data = getData(context);
      } else {
        timer = Timer.periodic(Duration(seconds: 2), (time) {
          if(!Navigator.of(context).canPop()){
            data = getData(context);
            setState((){});
            timer!.cancel();
          }
        });
      }
    };
    MyApp.socket!.on('serverNotification', onNotificationReceived!);
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    try {
      MyApp.socket!.off('serverNotification', onNotificationReceived);
    } catch(e) {
    }
    super.dispose();
  }

  List<Widget> cards = [];

  @override
  Widget build(BuildContext context) {

    ZoomDrawer.of(context)!.close();

    return FutureBuilder(
        future: data,
        builder: (BuildContext context, AsyncSnapshot snapshot){
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
              final value = snapshot.data;
              if(value['status'] == 'successful'){
                statusOk = true;
                complete = value['complete'];
                incomplete = value['incomplete'];
                checklists = value['checklists'] as List;
                assignments = value['assignments'] as List;
              } else {
                statusOk = false;
              }
              switch(snapshot.data['status']){
                case 'error':
                // sb = ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: const Text('Error'),
                //     action: SnackBarAction(
                //       label: 'okay',
                //       onPressed: () {
                //         // Code to execute.
                //       },
                //     ),
                //   ),
                // );
                  break;
                case 'network':
                // sb = ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: const Text('Not on the network!'),
                //     action: SnackBarAction(
                //       label: 'okay',
                //       onPressed: () {
                //         // Code to execute.
                //       },
                //     ),
                //   ),
                // );
                  break;
                case 'session-error-incomplete':
                // sb = ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: const Text('Invalid Session, unable to log out...'),
                //     action: SnackBarAction(
                //       label: 'okay',
                //       onPressed: () {
                //         // Code to execute.
                //       },
                //     ),
                //   ),
                // );
                  break;
                case 'session-error-complete':
                // sb = ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: const Text('Invalid Session, logging out...'),
                //     action: SnackBarAction(
                //       label: 'okay',
                //       onPressed: () {
                //         // Code to execute.
                //       },
                //     ),
                //   ),
                // );
                  break;
                default:
                // sb = ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: const Text('Error'),
                //     action: SnackBarAction(
                //       label: 'okay',
                //       onPressed: () {
                //         // Code to execute.
                //       },
                //     ),
                //   ),
                // );
                  break;
              }
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.black87,
                    leading: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: (){
                          ZoomDrawer.of(context)!.toggle();
                        }
                    ),
                    actions: [
                      Container(
                        width: ResponsiveValue(context, defaultValue: 150.0, valueWhen: [Condition.smallerThan(name: MOBILE, value: 100.0)]).value,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Container(
                                padding: EdgeInsets.only(left: ResponsiveValue(context, defaultValue: 20.0, valueWhen: [Condition.smallerThan(name: MOBILE, value: 20.0)]).value!),
                                child: Text(Login.location!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveValue(context, defaultValue: 20.0, valueWhen: [Condition.smallerThan(name: MOBILE, value: 10.0)]).value,
                                  ),
                                )
                            ),
                            isExpanded: true,
                            icon: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.keyboard_control,
                                color: Colors.white,
                              ),
                            ),
                            items: Login.locationSet.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String> (
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                Login.location = value;
                                data = getData(context);
                                //replaced
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: Scrollbar(
                    radius: Radius.circular(50),
                    interactive: true,
                    isAlwaysShown: true,
                    thickness: 10,
                    child: Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width,
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
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.9, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: MediaQuery.of(context).size.height * 3.3)]).value,
                            child: ResponsiveRowColumn(
                              layout: ResponsiveWrapper.of(context).isSmallerThan("LAPTOP") ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                              children: [
                                ResponsiveRowColumnItem(
                                  child: Expanded(
                                    flex: 7,
                                    child: Container(
                                      child: ResponsiveRowColumn(
                                        layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                                        columnVerticalDirection: ResponsiveWrapper.of(context).isSmallerThan("LAPTOP") ? VerticalDirection.up : VerticalDirection.down,
                                        children: [
                                          ResponsiveRowColumnItem(
                                            child: Expanded(
                                              flex: ResponsiveValue(context, defaultValue: 3, valueWhen: [Condition.largerThan(name: TABLET, value:
                                              ResponsiveValue(context, defaultValue: 1, valueWhen: [Condition.equals(name: "LAPTOP", value: 2)]).value!)]).value!,
                                              child: Container(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: ResponsiveValue(context, defaultValue: 0.0, valueWhen: [Condition.largerThan(name: TABLET, value: 30.0)]).value!,
                                                    bottom: ResponsiveValue(context, defaultValue: 0.0, valueWhen: [Condition.largerThan(name: TABLET, value:
                                                    ResponsiveValue(context, defaultValue: 30.0, valueWhen: [Condition.equals(name: "LAPTOP", value: 0.0)]).value!)]).value!,
                                                    left: ResponsiveValue(context, defaultValue: 0.0, valueWhen: [Condition.largerThan(name: TABLET, value:
                                                    ResponsiveValue(context, defaultValue: 30.0, valueWhen: [Condition.equals(name: "LAPTOP", value: 0.0)]).value!)]).value!,
                                                  ),
                                                  child: ResponsiveRowColumn(
                                                    layout: ResponsiveWrapper.of(context).equals("LAPTOP") ? ResponsiveRowColumnType.ROW : ResponsiveRowColumnType.COLUMN,
                                                    columnMainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    columnCrossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ResponsiveRowColumnItem(
                                                        child: Expanded(
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors.black87,
                                                                  border: Border.all(
                                                                    color: Colors.black,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                                              ),
                                                              margin: EdgeInsets.all(10),
                                                              width: double.infinity,
                                                              height: double.infinity,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'COMPLETE',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      statusOk ? complete.toString() : 'N/A',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w800,
                                                                          fontSize: 40,
                                                                          decorationThickness: 2.5,
                                                                          color: Colors.greenAccent
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                      ResponsiveRowColumnItem(
                                                        child: Expanded(
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors.black87,
                                                                  border: Border.all(
                                                                    color: Colors.black,
                                                                  ),
                                                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                                              ),
                                                              margin: EdgeInsets.all(10),
                                                              width: double.infinity,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'INCOMPLETE',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.white
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                        statusOk ? incomplete.toString() : 'N/A',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w800,
                                                                            fontSize: 40,
                                                                            decorationThickness: 2.5,
                                                                            color: Colors.redAccent
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ResponsiveRowColumnItem(
                                            child: Expanded(
                                              flex: ResponsiveValue(context, defaultValue: 5, valueWhen: [Condition.largerThan(name: TABLET, value:
                                              ResponsiveValue(context, defaultValue: 3, valueWhen: [Condition.equals(name: "LAPTOP", value: 5)]).value!)]).value!,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: ResponsiveValue(context, defaultValue: 0.0, valueWhen: [Condition.largerThan(name: TABLET, value:
                                                  ResponsiveValue(context, defaultValue: 30.0, valueWhen: [Condition.equals(name: "LAPTOP", value: 0.0)]).value!)]).value!,
                                                  bottom: ResponsiveValue(context, defaultValue: 0.0, valueWhen: [Condition.largerThan(name: TABLET, value: 30.0)]).value!,),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black87,
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                  ),
                                                  margin: EdgeInsets.all(15),
                                                  child: ResponsiveRowColumn(
                                                    layout: ResponsiveWrapper.of(context).isSmallerThan("LAPTOP") ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                                                    rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    columnMainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    columnVerticalDirection: VerticalDirection.up,
                                                    children: [
                                                      ResponsiveRowColumnItem(
                                                        child: Expanded(
                                                          child: Container(
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  Container(
                                                                      height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.9,
                                                                          valueWhen: [Condition.largerThan(name: TABLET, value: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.725,
                                                                              valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.50)]).value!)]).value!,
                                                                      width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.9,
                                                                          valueWhen: [Condition.largerThan(name: TABLET, value:
                                                                          ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.31,
                                                                              valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.40)]).value!)]).value!,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.white12),
                                                                      margin: EdgeInsets.all(ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.025,
                                                                          valueWhen: [Condition.largerThan(name: TABLET, value: 0.0)]).value!,),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text('OPEN CHECKLISTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          statusOk ? ListView.builder(
                                                                            shrinkWrap: true,
                                                                            itemCount: checklists.length,
                                                                            itemBuilder: (BuildContext context, int index) {
                                                                              return Container(
                                                                                margin: EdgeInsets.only(top: 10),
                                                                                width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.7,
                                                                                    valueWhen: [
                                                                                      Condition.equals(name: MOBILE, value: MediaQuery.of(context).size.width * 0.5),
                                                                                      Condition.equals(name: TABLET, value: MediaQuery.of(context).size.width * 0.4),
                                                                                      Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.12),
                                                                                      Condition.equals(name: DESKTOP, value: MediaQuery.of(context).size.width * 0.12),]).value!,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(checklists[index]['name'] + ' ' + checklists[index]['time'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                                                                      fontSize: ResponsiveValue(context, defaultValue: 10.0,
                                                                                          valueWhen: [
                                                                                            Condition.equals(name: MOBILE, value: 12.0),
                                                                                            Condition.equals(name: TABLET, value: 14.0),
                                                                                            Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.017),
                                                                                            Condition.equals(name: DESKTOP, value: 16.0),]).value!,)),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                          ) : Container(
                                                                              child: Text('N/A')
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ]
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      ResponsiveRowColumnItem(
                                                        child: Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Container(
                                                                  height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.9,
                                                                      valueWhen: [Condition.largerThan(name: TABLET, value: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.725,
                                                                          valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.50)]).value!)]).value!,
                                                                  width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.9,
                                                                      valueWhen: [Condition.largerThan(name: TABLET, value:
                                                                      ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.31,
                                                                          valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.40)]).value!)]).value!,
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.white12),
                                                                  margin: EdgeInsets.all(ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.025,
                                                                      valueWhen: [Condition.largerThan(name: TABLET, value: 0.0)]).value!,),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        'ASSIGNMENTS',
                                                                        style: new TextStyle(fontWeight: FontWeight.bold,
                                                                            color: Colors.white
                                                                        ),
                                                                      ),
                                                                      statusOk ? ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: assignments.length,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return Container(
                                                                            margin: EdgeInsets.only(top: 10),
                                                                            width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.7,
                                                                                valueWhen: [
                                                                                  Condition.equals(name: MOBILE, value: MediaQuery.of(context).size.width * 0.5),
                                                                                  Condition.equals(name: TABLET, value: MediaQuery.of(context).size.width * 0.4),
                                                                                  Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.12),
                                                                                  Condition.equals(name: DESKTOP, value: MediaQuery.of(context).size.width * 0.12),]).value!,
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text('${index + 1}. ' + assignments[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                                                                  fontSize: ResponsiveValue(context, defaultValue: 10.0,
                                                                                      valueWhen: [
                                                                                        Condition.equals(name: MOBILE, value: 12.0),
                                                                                        Condition.equals(name: TABLET, value: 14.0),
                                                                                        Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.017),
                                                                                        Condition.equals(name: DESKTOP, value: 16.0),]).value!,)),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ) : Container(
                                                                          child: Text('N/A')
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
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
                              TextButton(
                                child: Text(
                                    'Click Here',
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                        fontSize: MediaQuery.of(context).size.width * 0.02
                                    )
                                ),
                                onPressed: (){
                                  data = getData(context);
                                  setState(() {

                                  });
                                },
                              ),
                            ],
                          )
                      ),
                    )
                ),
              ],
            ));
          }
        }
    );
  }
}
