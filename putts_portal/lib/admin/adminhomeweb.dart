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

class AdminHomeWeb extends StatefulWidget {
  const AdminHomeWeb({Key? key}) : super(key: key);

  @override
  _AdminHomeWebState createState() => _AdminHomeWebState();
}

class _AdminHomeWebState extends State<AdminHomeWeb> {

  List<_ChartData> data = [];
  late TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  bool allTime = true;
  bool wantRange = false;
  DateTime selectedDay = DateTime.now();
  PickerDateRange selectedRange = new PickerDateRange(DateTime.now(), DateTime.now());

  double completionPercentage = 0;
  int complete = 0;
  int incomplete = 0;
  List<DataRow> mandatoryCompletion = [];
  List users = [];
  List departments = [];
  List averages = [];
  bool statusOk = false;
  EventHandler? onNotificationReceived;
  bool refreshingPage = false;
  Future<Map>? reportingData;
  Future<Map> getReportingData(bool allTime, bool wantRange, DateTime selectedDay, PickerDateRange selectedRange, BuildContext context) async {
    String? responseBody;
    Response? responses;
    //replaced
    Map temp = new Map();
    if(allTime){
      final Uri url = Uri.parse('http://' + Login.localhost + ':8080/reporting/data/?allTime=true&range=false&single_day=none&range_start_day=none&range_end_day=none');
      try {
        await HttpClientHelper.get(url, retries: 3, timeRetry: Duration(milliseconds: 100), timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'location': Login.location!, 'sessionId': Login.sessionId!}).then((Response? response) => {
          responseBody = response!.body,
          responses = response
        });
      } catch(e){
        temp['status'] = 'network';
        return temp;
      }
      var json = await jsonDecode(responseBody!);

      temp['status'] = json['status'];
      temp['completionPercentage'] = json['completionPercentage'];
      temp['complete'] = json['complete'];
      temp['incomplete'] = json['incomplete'];
      temp['mandatoryCompletion'] = json['mandatoryCompletion'];
      temp['users'] = json['users'];
      temp['departments'] = json['departments'];
      temp['averages'] = json['averages'];

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
    } else {
      if(wantRange){
        if(selectedRange.endDate != null){
          final Uri url = Uri.parse('http://' + Login.localhost + ':8080/reporting/data?allTime=false&range=true&single_day=none&range_start_day=' + selectedRange.startDate.toString() + '&range_end_day=' + selectedRange.endDate.toString());
          try {
            await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'location': Login.location!, 'sessionId': Login.sessionId!}).then((Response? response) => {
              responseBody = response!.body,
              responses = response
            });
          } catch(e){
            temp['status'] = 'network';
            return temp;
          }
          var json = await jsonDecode(responseBody!);
          temp['status'] = json['status'];
          temp['completionPercentage'] = json['completionPercentage'];
          temp['complete'] = json['complete'];
          temp['incomplete'] = json['incomplete'];
          temp['mandatoryCompletion'] = json['mandatoryCompletion'];
          temp['users'] = json['users'];
          temp['departments'] = json['departments'];
          temp['averages'] = json['averages'];
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
            }
          } catch (e){
            //continue
          }
          return temp;
        } else {
          temp['status'] = 'error';
          return temp;
        }
      } else {
        final Uri url = Uri.parse('http://' + Login.localhost + ':8080/reporting/data?allTime=false&range=false&single_day=' + selectedDay.toString() + '&range_start_day=none&range_end_day=none');
        try {
          await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'location': Login.location!, 'sessionId': Login.sessionId!}).then((Response? response) => {
            responseBody = response!.body,
            responses = response
          });
        } catch(e){
          temp['status'] = 'network';
          return temp;
        }
        var json = await jsonDecode(responseBody!);
        temp['status'] = json['status'];
        temp['completionPercentage'] = json['completionPercentage'];
        temp['complete'] = json['complete'];
        temp['incomplete'] = json['incomplete'];
        temp['mandatoryCompletion'] = json['mandatoryCompletion'];
        temp['users'] = json['users'];
        temp['departments'] = json['departments'];
        temp['averages'] = json['averages'];
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
            temp['status'] = 'error-session-complete';
            return temp;
          }
        } catch (e){
          //continue
        }
        return temp;
      }
    }
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


  @override
  void didChangeDependencies(){
    if(!Navigator.of(context).canPop()){
      reportingData = getReportingData(allTime, false, selectedDay, selectedRange, context);
    }
    onNotificationReceived = (notification) async {
      if(!Navigator.of(context).canPop()){
        reportingData = getReportingData(allTime, false, selectedDay, selectedRange, context);
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
        future: reportingData,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.black87,
                  leading: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        ZoomDrawer.of(context)!.toggle();
                      }
                  ),
                  actions: [
                    Container(
                      width: ResponsiveValue(context, defaultValue: 150.0,
                          valueWhen: [
                            Condition.smallerThan(name: MOBILE, value: 100.0)
                          ]).value,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Container(
                              padding: EdgeInsets.only(left: ResponsiveValue(
                                  context, defaultValue: 20.0,
                                  valueWhen: [
                                    Condition.smallerThan(
                                        name: MOBILE, value: 20.0)
                                  ]).value!),
                              child: Text(Login.location!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveValue(
                                      context, defaultValue: 20.0,
                                      valueWhen: [
                                        Condition.smallerThan(
                                            name: MOBILE, value: 10.0)
                                      ]).value,
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
                          items: Login.locationSet.map<DropdownMenuItem<String>>((
                              String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              Login.location = value;
                              if (allTime == true) {
                                reportingData = getReportingData(
                                    allTime, false, new DateTime(0),
                                    new PickerDateRange(
                                        new DateTime(0), new DateTime(0)),
                                    context);
                              } else {
                                reportingData = getReportingData(
                                    allTime, wantRange, selectedDay,
                                    selectedRange, context);
                              }
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          'ALL TIME',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                      Checkbox(
                                          activeColor: Colors.black,
                                          value: allTime,
                                          onChanged: (value) {
                                            setState(() {
                                              allTime = value!;
                                              if (allTime == true) {
                                                reportingData = getReportingData(
                                                    allTime, false,
                                                    new DateTime(0),
                                                    new PickerDateRange(
                                                        new DateTime(0),
                                                        new DateTime(0)),
                                                    context);
                                              }
                                            });
                                          }
                                      ),
                                    ],
                                  ),
                                ]
                            )
                        ),
                        Container(
                          height: ResponsiveValue(
                              context, defaultValue: MediaQuery
                              .of(context)
                              .size
                              .height * 0.9, valueWhen: [
                            Condition.smallerThan(
                                name: "LAPTOP", value: MediaQuery
                                .of(context)
                                .size
                                .height * 3.3)
                          ]).value,
                          child: ResponsiveRowColumn(
                            layout: ResponsiveWrapper.of(context).isSmallerThan(
                                "LAPTOP")
                                ? ResponsiveRowColumnType.COLUMN
                                : ResponsiveRowColumnType.ROW,
                            children: [
                              ResponsiveRowColumnItem(
                                child: Expanded(
                                  flex: 7,
                                  child: Container(
                                    child: ResponsiveRowColumn(
                                      layout: ResponsiveWrapper.of(context)
                                          .isSmallerThan(DESKTOP)
                                          ? ResponsiveRowColumnType.COLUMN
                                          : ResponsiveRowColumnType.ROW,
                                      columnVerticalDirection: ResponsiveWrapper
                                          .of(context).isSmallerThan("LAPTOP")
                                          ? VerticalDirection.up
                                          : VerticalDirection.down,
                                      children: [
                                        ResponsiveRowColumnItem(
                                          child: Expanded(
                                            flex: ResponsiveValue(
                                                context, defaultValue: 3,
                                                valueWhen: [
                                                  Condition.largerThan(
                                                      name: TABLET, value:
                                                  ResponsiveValue(
                                                      context, defaultValue: 1,
                                                      valueWhen: [
                                                        Condition.equals(
                                                            name: "LAPTOP",
                                                            value: 2)
                                                      ]).value!)
                                                ]).value!,
                                            child: Container(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: ResponsiveValue(
                                                      context, defaultValue: 0.0,
                                                      valueWhen: [
                                                        Condition.largerThan(
                                                            name: TABLET,
                                                            value: 30.0)
                                                      ]).value!,
                                                  bottom: ResponsiveValue(
                                                      context, defaultValue: 0.0,
                                                      valueWhen: [
                                                        Condition.largerThan(
                                                            name: TABLET, value:
                                                        ResponsiveValue(context,
                                                            defaultValue: 30.0,
                                                            valueWhen: [
                                                              Condition.equals(
                                                                  name: "LAPTOP",
                                                                  value: 0.0)
                                                            ]).value!)
                                                      ]).value!,
                                                  left: ResponsiveValue(
                                                      context, defaultValue: 0.0,
                                                      valueWhen: [
                                                        Condition.largerThan(
                                                            name: TABLET, value:
                                                        ResponsiveValue(context,
                                                            defaultValue: 30.0,
                                                            valueWhen: [
                                                              Condition.equals(
                                                                  name: "LAPTOP",
                                                                  value: 0.0)
                                                            ]).value!)
                                                      ]).value!,
                                                ),
                                                child: ResponsiveRowColumn(
                                                  layout: ResponsiveWrapper.of(
                                                      context).equals("LAPTOP")
                                                      ? ResponsiveRowColumnType
                                                      .ROW
                                                      : ResponsiveRowColumnType
                                                      .COLUMN,
                                                  columnMainAxisAlignment: MainAxisAlignment
                                                      .spaceAround,
                                                  rowMainAxisAlignment: MainAxisAlignment
                                                      .spaceAround,
                                                  columnCrossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    ResponsiveRowColumnItem(
                                                      child: Expanded(
                                                        child: InkWell(
                                                          hoverColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            Navigator.of(context)
                                                                .pushNamed(
                                                                '/complete');
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black87,
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  borderRadius: BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                      20))
                                                              ),
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .all(8.0),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Text(
                                                                      'COMPLETE',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      statusOk
                                                                          ? complete
                                                                          .toString()
                                                                          : 'N/A',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          fontSize: 40,
                                                                          decorationThickness: 2.5,
                                                                          color: Colors
                                                                              .greenAccent
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                    ResponsiveRowColumnItem(
                                                      child: Expanded(
                                                        child: InkWell(
                                                          hoverColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            Navigator.of(context)
                                                                .pushNamed(
                                                                '/incomplete');
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black87,
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  borderRadius: BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                      20))
                                                              ),
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              width: double
                                                                  .infinity,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .all(8.0),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Text(
                                                                      'INCOMPLETE',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                        statusOk
                                                                            ? incomplete
                                                                            .toString()
                                                                            : 'N/A',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w800,
                                                                            fontSize: 40,
                                                                            decorationThickness: 2.5,
                                                                            color: Colors
                                                                                .redAccent
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                    ResponsiveRowColumnItem(
                                                      child: Expanded(
                                                        child: InkWell(
                                                          hoverColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            Navigator.of(context)
                                                                .pushNamed(
                                                                '/areasofconcern');
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black87,
                                                                border: Border
                                                                    .all(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                    .circular(20))
                                                            ),
                                                            margin: EdgeInsets
                                                                .all(10),
                                                            width: double
                                                                .infinity,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .only(left: 8,
                                                                  right: 8),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    'AREAS OF CONCERN',
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .white
                                                                    ),
                                                                  ),
                                                                  statusOk
                                                                      ? ListView
                                                                      .builder(
                                                                      shrinkWrap: true,
                                                                      itemCount: departments
                                                                          .length >=
                                                                          3
                                                                          ? 3
                                                                          : departments
                                                                          .length,
                                                                      itemBuilder: (
                                                                          context,
                                                                          index) {
                                                                        Department department = departments[index] as Department;
                                                                        return Container(
                                                                          width: ResponsiveValue(
                                                                              context,
                                                                              defaultValue: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.125,
                                                                              valueWhen: [
                                                                                Condition
                                                                                    .smallerThan(
                                                                                    name: "LAPTOP",
                                                                                    value:
                                                                                    MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .width *
                                                                                        0.7)
                                                                              ])
                                                                              .value!,
                                                                          child: LinearPercentIndicator(
                                                                            animation: true,
                                                                            lineHeight: ResponsiveValue(
                                                                                context,
                                                                                defaultValue: MediaQuery
                                                                                    .of(
                                                                                    context)
                                                                                    .size
                                                                                    .height *
                                                                                    0.01,
                                                                                valueWhen: [
                                                                                  Condition
                                                                                      .smallerThan(
                                                                                      name: "LAPTOP",
                                                                                      value:
                                                                                      MediaQuery
                                                                                          .of(
                                                                                          context)
                                                                                          .size
                                                                                          .height *
                                                                                          0.025)
                                                                                ])
                                                                                .value!,
                                                                            animationDuration: 2000,
                                                                            percent: department
                                                                                .completionPercentage ==
                                                                                -1
                                                                                ? 0.0
                                                                                : (department
                                                                                .completionPercentage! /
                                                                                100),
                                                                            leading: Padding(
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  right: 5),
                                                                              child: Text(
                                                                                  department
                                                                                      .name!,
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .white)),
                                                                            ),
                                                                            trailing: Padding(
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  left: 5.0),
                                                                              child: Text(
                                                                                  department
                                                                                      .completionPercentage ==
                                                                                      -1
                                                                                      ? '0%'
                                                                                      : department
                                                                                      .completionPercentage
                                                                                      .toString() +
                                                                                      '%',
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .white)),
                                                                            ),
                                                                            linearStrokeCap: LinearStrokeCap
                                                                                .roundAll,
                                                                            progressColor: Colors
                                                                                .redAccent,
                                                                          ),
                                                                        );
                                                                      }
                                                                  )
                                                                      : Container(
                                                                      child: Text(
                                                                          'N/A')
                                                                  ),
                                                                ],
                                                              ),
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
                                        ),
                                        ResponsiveRowColumnItem(
                                          child: Expanded(
                                            flex: ResponsiveValue(
                                                context, defaultValue: 5,
                                                valueWhen: [
                                                  Condition.largerThan(
                                                      name: TABLET, value:
                                                  ResponsiveValue(
                                                      context, defaultValue: 3,
                                                      valueWhen: [
                                                        Condition.equals(
                                                            name: "LAPTOP",
                                                            value: 5)
                                                      ]).value!)
                                                ]).value!,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: ResponsiveValue(
                                                    context, defaultValue: 0.0,
                                                    valueWhen: [
                                                      Condition.largerThan(
                                                          name: TABLET, value:
                                                      ResponsiveValue(context,
                                                          defaultValue: 30.0,
                                                          valueWhen: [
                                                            Condition.equals(
                                                                name: "LAPTOP",
                                                                value: 0.0)
                                                          ]).value!)
                                                    ]).value!,
                                                bottom: ResponsiveValue(
                                                    context, defaultValue: 0.0,
                                                    valueWhen: [
                                                      Condition.largerThan(
                                                          name: TABLET,
                                                          value: 30.0)
                                                    ]).value!,),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.black87,
                                                    border: Border.all(
                                                      color: Colors.black,
                                                    ),
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(20))
                                                ),
                                                margin: EdgeInsets.all(15),
                                                child: ResponsiveRowColumn(
                                                  layout: ResponsiveWrapper.of(
                                                      context).isSmallerThan(
                                                      "LAPTOP")
                                                      ? ResponsiveRowColumnType
                                                      .COLUMN
                                                      : ResponsiveRowColumnType
                                                      .ROW,
                                                  rowMainAxisAlignment: MainAxisAlignment
                                                      .spaceAround,
                                                  columnMainAxisAlignment: MainAxisAlignment
                                                      .spaceAround,
                                                  columnVerticalDirection: VerticalDirection
                                                      .up,
                                                  children: [
                                                    ResponsiveRowColumnItem(
                                                      child: Expanded(
                                                        child: Container(
                                                          child: Column(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                InkWell(
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                        context)
                                                                        .pushNamed(
                                                                        '/usercompletion');
                                                                  },
                                                                  child: Container(
                                                                      height: ResponsiveValue(
                                                                          context,
                                                                          defaultValue: MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .size
                                                                              .height *
                                                                              0.41,
                                                                          valueWhen: [
                                                                            Condition
                                                                                .largerThan(
                                                                                name: TABLET,
                                                                                value: ResponsiveValue(
                                                                                    context,
                                                                                    defaultValue: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .height *
                                                                                        0.31,
                                                                                    valueWhen: [
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: "LAPTOP",
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .height *
                                                                                              0.25)
                                                                                    ])
                                                                                    .value!)
                                                                          ])
                                                                          .value!,
                                                                      width: ResponsiveValue(
                                                                          context,
                                                                          defaultValue: MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .size
                                                                              .width *
                                                                              0.9,
                                                                          valueWhen: [
                                                                            Condition
                                                                                .largerThan(
                                                                                name: TABLET,
                                                                                value:
                                                                                ResponsiveValue(
                                                                                    context,
                                                                                    defaultValue: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .width *
                                                                                        0.21,
                                                                                    valueWhen: [
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: "LAPTOP",
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .width *
                                                                                              0.25)
                                                                                    ])
                                                                                    .value!)
                                                                          ])
                                                                          .value!,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius
                                                                              .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  30)),
                                                                          color: Colors
                                                                              .white12),
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                        ResponsiveValue(
                                                                            context,
                                                                            defaultValue: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .width *
                                                                                0.025,
                                                                            valueWhen: [
                                                                              Condition
                                                                                  .largerThan(
                                                                                  name: TABLET,
                                                                                  value: 0.0)
                                                                            ])
                                                                            .value!,),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .center,
                                                                        children: [
                                                                          Text(
                                                                              'USER COMPLETION %',
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontWeight: FontWeight
                                                                                      .bold)),
                                                                          statusOk
                                                                              ? ListView
                                                                              .builder(
                                                                            shrinkWrap: true,
                                                                            itemCount: users
                                                                                .length >=
                                                                                3
                                                                                ? 3
                                                                                : users
                                                                                .length,
                                                                            itemBuilder: (
                                                                                BuildContext context,
                                                                                int index) {
                                                                              User user = users[index] as User;
                                                                              return Container(
                                                                                margin: EdgeInsets
                                                                                    .only(
                                                                                    top: 10),
                                                                                width: ResponsiveValue(
                                                                                    context,
                                                                                    defaultValue: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .width *
                                                                                        0.7,
                                                                                    valueWhen: [
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: MOBILE,
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .width *
                                                                                              0.5),
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: TABLET,
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .width *
                                                                                              0.4),
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: "LAPTOP",
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .width *
                                                                                              0.12),
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: DESKTOP,
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .width *
                                                                                              0.12),
                                                                                    ])
                                                                                    .value!,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                                      .start,
                                                                                  children: [
                                                                                    Text(
                                                                                        user
                                                                                            .name!,
                                                                                        style: TextStyle(
                                                                                          color: Colors
                                                                                              .white,
                                                                                          fontWeight: FontWeight
                                                                                              .bold,
                                                                                          fontSize: ResponsiveValue(
                                                                                              context,
                                                                                              defaultValue: 10.0,
                                                                                              valueWhen: [
                                                                                                Condition
                                                                                                    .equals(
                                                                                                    name: MOBILE,
                                                                                                    value: 12.0),
                                                                                                Condition
                                                                                                    .equals(
                                                                                                    name: TABLET,
                                                                                                    value: 14.0),
                                                                                                Condition
                                                                                                    .equals(
                                                                                                    name: "LAPTOP",
                                                                                                    value: MediaQuery
                                                                                                        .of(
                                                                                                        context)
                                                                                                        .size
                                                                                                        .height *
                                                                                                        0.017),
                                                                                                Condition
                                                                                                    .equals(
                                                                                                    name: DESKTOP,
                                                                                                    value: 16.0),
                                                                                              ])
                                                                                              .value!,)),
                                                                                    LinearPercentIndicator(
                                                                                      animation: true,
                                                                                      lineHeight: ResponsiveValue(
                                                                                          context,
                                                                                          defaultValue: 18.0,
                                                                                          valueWhen:
                                                                                          [
                                                                                            Condition
                                                                                                .largerThan(
                                                                                                name: TABLET,
                                                                                                value: MediaQuery
                                                                                                    .of(
                                                                                                    context)
                                                                                                    .size
                                                                                                    .height *
                                                                                                    0.01)
                                                                                          ])
                                                                                          .value!,
                                                                                      animationDuration: 2000,
                                                                                      percent: user
                                                                                          .completionPercentage! /
                                                                                          100,
                                                                                      trailing: Padding(
                                                                                        padding: const EdgeInsets
                                                                                            .only(
                                                                                            left: 5),
                                                                                        child: Text(
                                                                                            user
                                                                                                .completionPercentage
                                                                                                .toString() +
                                                                                                '%',
                                                                                            style: TextStyle(
                                                                                                color: Colors
                                                                                                    .white)),
                                                                                      ),
                                                                                      linearStrokeCap: LinearStrokeCap
                                                                                          .roundAll,
                                                                                      progressColor: Colors
                                                                                          .greenAccent,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                          )
                                                                              : Container(
                                                                              child: Text(
                                                                                  'N/A')
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                                InkWell(
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                        context)
                                                                        .pushNamed(
                                                                        '/mandatoryincompletion');
                                                                  },
                                                                  child: Container(
                                                                      height: ResponsiveValue(
                                                                          context,
                                                                          defaultValue: MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .size
                                                                              .height *
                                                                              0.41,
                                                                          valueWhen: [
                                                                            Condition
                                                                                .largerThan(
                                                                                name: TABLET,
                                                                                value: ResponsiveValue(
                                                                                    context,
                                                                                    defaultValue: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .height *
                                                                                        0.31,
                                                                                    valueWhen: [
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: "LAPTOP",
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .height *
                                                                                              0.25)
                                                                                    ])
                                                                                    .value!)
                                                                          ])
                                                                          .value!,
                                                                      width: ResponsiveValue(
                                                                          context,
                                                                          defaultValue: MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .size
                                                                              .width *
                                                                              0.9,
                                                                          valueWhen: [
                                                                            Condition
                                                                                .largerThan(
                                                                                name: TABLET,
                                                                                value:
                                                                                ResponsiveValue(
                                                                                    context,
                                                                                    defaultValue: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .width *
                                                                                        0.21,
                                                                                    valueWhen: [
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: "LAPTOP",
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .width *
                                                                                              0.25)
                                                                                    ])
                                                                                    .value!)
                                                                          ])
                                                                          .value!,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius
                                                                              .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  30)),
                                                                          color: Colors
                                                                              .white12),
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                        ResponsiveValue(
                                                                            context,
                                                                            defaultValue: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .width *
                                                                                0.025,
                                                                            valueWhen: [
                                                                              Condition
                                                                                  .largerThan(
                                                                                  name: TABLET,
                                                                                  value: 0.0)
                                                                            ])
                                                                            .value!,),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .center,
                                                                        children: [
                                                                          Text(
                                                                              'MANDATORY INCOMPLETION',
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontWeight: FontWeight
                                                                                      .bold)),
                                                                          statusOk
                                                                              ? Container(
                                                                            child: DataTable(
                                                                              headingRowHeight: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.05,
                                                                              dataRowHeight: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.04,
                                                                              columnSpacing: 22.5,
                                                                              dataTextStyle: TextStyle(
                                                                                fontSize: ResponsiveValue(
                                                                                    context,
                                                                                    defaultValue: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .height *
                                                                                        0.0159,
                                                                                    valueWhen: [
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: MOBILE,
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .height *
                                                                                              0.0159),
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: TABLET,
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .height *
                                                                                              0.0159),
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: "LAPTOP",
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .height *
                                                                                              0.0159),
                                                                                      Condition
                                                                                          .equals(
                                                                                          name: DESKTOP,
                                                                                          value: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .size
                                                                                              .height *
                                                                                              0.0159),
                                                                                    ])
                                                                                    .value!,
                                                                                color: Colors
                                                                                    .amber,
                                                                              ),
                                                                              horizontalMargin: 0,
                                                                              columns: [
                                                                                DataColumn(
                                                                                    label: Text(
                                                                                        'Name',
                                                                                        style: TextStyle(
                                                                                            color: Colors
                                                                                                .white,
                                                                                            fontSize: MediaQuery
                                                                                                .of(
                                                                                                context)
                                                                                                .size
                                                                                                .height *
                                                                                                0.0159))),
                                                                                DataColumn(
                                                                                    label: Text(
                                                                                        'Date',
                                                                                        style: TextStyle(
                                                                                            color: Colors
                                                                                                .white,
                                                                                            fontSize: MediaQuery
                                                                                                .of(
                                                                                                context)
                                                                                                .size
                                                                                                .height *
                                                                                                0.0159))),
                                                                                DataColumn(
                                                                                    tooltip: 'Days overdue',
                                                                                    label: Text(
                                                                                        'Over',
                                                                                        style: TextStyle(
                                                                                            color: Colors
                                                                                                .white,
                                                                                            fontSize: MediaQuery
                                                                                                .of(
                                                                                                context)
                                                                                                .size
                                                                                                .height *
                                                                                                0.0159)))
                                                                              ],
                                                                              rows: mandatoryCompletion,
                                                                            ),
                                                                          )
                                                                              : Container(
                                                                            child: Text(
                                                                                'N/A'),
                                                                          )
                                                                        ],
                                                                      )),
                                                                ),
                                                              ]
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ResponsiveRowColumnItem(
                                                      child: Expanded(
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              Container(
                                                                height: ResponsiveValue(
                                                                    context,
                                                                    defaultValue: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .height *
                                                                        0.41,
                                                                    valueWhen: [
                                                                      Condition
                                                                          .largerThan(
                                                                          name: TABLET,
                                                                          value: ResponsiveValue(
                                                                              context,
                                                                              defaultValue: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.31,
                                                                              valueWhen: [
                                                                                Condition
                                                                                    .equals(
                                                                                    name: "LAPTOP",
                                                                                    value: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .height *
                                                                                        0.25)
                                                                              ])
                                                                              .value!)
                                                                    ]).value!,
                                                                width: ResponsiveValue(
                                                                    context,
                                                                    defaultValue: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        0.9,
                                                                    valueWhen: [
                                                                      Condition
                                                                          .largerThan(
                                                                          name: TABLET,
                                                                          value:
                                                                          ResponsiveValue(
                                                                              context,
                                                                              defaultValue: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.21,
                                                                              valueWhen: [
                                                                                Condition
                                                                                    .equals(
                                                                                    name: "LAPTOP",
                                                                                    value: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .width *
                                                                                        0.25)
                                                                              ])
                                                                              .value!)
                                                                    ]).value!,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            30)),
                                                                    color: Colors
                                                                        .white12),
                                                                margin: EdgeInsets
                                                                    .all(
                                                                  ResponsiveValue(
                                                                      context,
                                                                      defaultValue: MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .width *
                                                                          0.025,
                                                                      valueWhen: [
                                                                        Condition
                                                                            .largerThan(
                                                                            name: TABLET,
                                                                            value: 0.0)
                                                                      ]).value!,),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Text(
                                                                      'COMPLETION PERCENTAGE',
                                                                      style: new TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                          15),
                                                                      child: new CircularPercentIndicator(
                                                                        radius: ResponsiveValue(
                                                                            context,
                                                                            defaultValue: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .height *
                                                                                0.275,
                                                                            valueWhen: [
                                                                              Condition
                                                                                  .equals(
                                                                                  name: MOBILE,
                                                                                  value: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .size
                                                                                      .height *
                                                                                      0.30),
                                                                              Condition
                                                                                  .equals(
                                                                                  name: TABLET,
                                                                                  value: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .size
                                                                                      .height *
                                                                                      0.30),
                                                                              Condition
                                                                                  .equals(
                                                                                  name: "LAPTOP",
                                                                                  value: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .size
                                                                                      .height *
                                                                                      0.17),
                                                                              Condition
                                                                                  .equals(
                                                                                  name: DESKTOP,
                                                                                  value: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .size
                                                                                      .height *
                                                                                      0.2),
                                                                            ])
                                                                            .value!,
                                                                        lineWidth: 20.0,
                                                                        animation: true,
                                                                        percent: statusOk
                                                                            ? completionPercentage /
                                                                            100
                                                                            : 0.0,
                                                                        center: new Text(
                                                                          statusOk
                                                                              ? completionPercentage
                                                                              .toString() +
                                                                              '%'
                                                                              : 'N/A',
                                                                          style:
                                                                          new TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              fontSize: 20.0,
                                                                              color: Colors
                                                                                  .white),
                                                                        ),
                                                                        circularStrokeCap: CircularStrokeCap
                                                                            .round,
                                                                        progressColor: Colors
                                                                            .greenAccent,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                onTap: () {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pushNamed(
                                                                      '/averagecompletiontimes');
                                                                },
                                                                child: Container(
                                                                    height: ResponsiveValue(
                                                                        context,
                                                                        defaultValue: MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .height *
                                                                            0.41,
                                                                        valueWhen: [
                                                                          Condition
                                                                              .largerThan(
                                                                              name: TABLET,
                                                                              value: ResponsiveValue(
                                                                                  context,
                                                                                  defaultValue: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .size
                                                                                      .height *
                                                                                      0.31,
                                                                                  valueWhen: [
                                                                                    Condition
                                                                                        .equals(
                                                                                        name: "LAPTOP",
                                                                                        value: MediaQuery
                                                                                            .of(
                                                                                            context)
                                                                                            .size
                                                                                            .height *
                                                                                            0.25)
                                                                                  ])
                                                                                  .value!)
                                                                        ]).value!,
                                                                    width: ResponsiveValue(
                                                                        context,
                                                                        defaultValue: MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .width *
                                                                            0.9,
                                                                        valueWhen: [
                                                                          Condition
                                                                              .largerThan(
                                                                              name: TABLET,
                                                                              value:
                                                                              ResponsiveValue(
                                                                                  context,
                                                                                  defaultValue: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .size
                                                                                      .width *
                                                                                      0.21,
                                                                                  valueWhen: [
                                                                                    Condition
                                                                                        .equals(
                                                                                        name: "LAPTOP",
                                                                                        value: MediaQuery
                                                                                            .of(
                                                                                            context)
                                                                                            .size
                                                                                            .width *
                                                                                            0.25)
                                                                                  ])
                                                                                  .value!)
                                                                        ]).value!,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .all(
                                                                            Radius
                                                                                .circular(
                                                                                30)),
                                                                        color: Colors
                                                                            .white12),
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                      ResponsiveValue(
                                                                          context,
                                                                          defaultValue: MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .size
                                                                              .width *
                                                                              0.025,
                                                                          valueWhen: [
                                                                            Condition
                                                                                .largerThan(
                                                                                name: TABLET,
                                                                                value: 0.0)
                                                                          ])
                                                                          .value!,),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Text(
                                                                            'AVERAGE COMPLETION TIMES',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontWeight: FontWeight
                                                                                    .bold)),
                                                                        statusOk
                                                                            ? Padding(
                                                                            padding: const EdgeInsets
                                                                                .all(
                                                                                8.0),
                                                                            child: ListView
                                                                                .builder(
                                                                                itemCount: averages
                                                                                    .length,
                                                                                shrinkWrap: true,
                                                                                itemBuilder: (
                                                                                    context,
                                                                                    index) {
                                                                                  ChecklistAverage checklistAverage = averages[index] as ChecklistAverage;
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .all(
                                                                                        5.0),
                                                                                    child: Text(
                                                                                        '${checklistAverage
                                                                                            .name} - ${checklistAverage
                                                                                            .average}',
                                                                                        style: TextStyle(
                                                                                            fontSize: 14,
                                                                                            color: Colors
                                                                                                .white)),
                                                                                  );
                                                                                }
                                                                            )
                                                                        )
                                                                            : Container(
                                                                            child: Text(
                                                                                'N/A')
                                                                        ),
                                                                      ],
                                                                    )),
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
                              ResponsiveRowColumnItem(
                                child: ResponsiveValue(
                                    context, defaultValue: Container(),
                                    valueWhen: [
                                      Condition.largerThan(name: TABLET, value:
                                      Container(
                                        child: Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30, bottom: 30),
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black87,
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .all(
                                                              Radius.circular(20))
                                                      ),
                                                      margin: EdgeInsets.all(10),
                                                      child: SfDateRangePicker(
                                                        initialSelectedRange: selectedRange,
                                                        view: DateRangePickerView
                                                            .month,
                                                        selectionMode: wantRange
                                                            ? DateRangePickerSelectionMode
                                                            .extendableRange
                                                            : DateRangePickerSelectionMode
                                                            .single,
                                                        initialSelectedDate: selectedDay,
                                                        confirmText: wantRange
                                                            ? "RANGE +"
                                                            : "RANGE -",
                                                        cancelText: "CLEAR",
                                                        onCancel: () {
                                                          selectedRange =
                                                          new PickerDateRange(
                                                              DateTime.now(),
                                                              DateTime.now());
                                                          selectedDay =
                                                              DateTime.now();
                                                          setState(() {});
                                                          reportingData =
                                                              getReportingData(
                                                                  allTime,
                                                                  wantRange,
                                                                  selectedDay,
                                                                  selectedRange,
                                                                  context);
                                                        },
                                                        onSubmit: (value) {
                                                          setState(() {
                                                            wantRange =
                                                            !wantRange;
                                                          });
                                                        },
                                                        onSelectionChanged: (
                                                            value) {
                                                          //replaced
                                                          if (wantRange) {
                                                            selectedRange = value
                                                                .value as PickerDateRange;
                                                            if (selectedRange
                                                                .startDate !=
                                                                null &&
                                                                selectedRange
                                                                    .endDate !=
                                                                    null) {
                                                              setState(() {});
                                                            }
                                                          } else {
                                                            selectedDay = value
                                                                .value as DateTime;
                                                            setState(() {});
                                                          }
                                                          reportingData =
                                                              getReportingData(
                                                                  allTime,
                                                                  wantRange,
                                                                  selectedDay,
                                                                  selectedRange,
                                                                  context);
                                                        },
                                                        selectionTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .bold,),
                                                        rangeTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .bold,),
                                                        startRangeSelectionColor: Colors
                                                            .greenAccent,
                                                        endRangeSelectionColor: Colors
                                                            .greenAccent,
                                                        selectionColor: Colors
                                                            .greenAccent,
                                                        rangeSelectionColor: Colors
                                                            .greenAccent
                                                            .withOpacity(0.70),
                                                        backgroundColor: Colors
                                                            .transparent,
                                                        monthViewSettings: DateRangePickerMonthViewSettings(
                                                          viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .amber),
                                                          ),
                                                        ),
                                                        yearCellStyle: DateRangePickerYearCellStyle(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        headerStyle: DateRangePickerHeaderStyle(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .amber),
                                                        ),
                                                        monthCellStyle: DateRangePickerMonthCellStyle(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        showActionButtons: true,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .all(
                                                              Radius.circular(20))
                                                      ),
                                                      margin: EdgeInsets.all(10),
                                                      child: SfCartesianChart(
                                                          primaryXAxis: CategoryAxis(),
                                                          primaryYAxis: NumericAxis(
                                                              minimum: 0,
                                                              maximum: 40,
                                                              interval: 10),
                                                          tooltipBehavior: _tooltip,
                                                          series: <ChartSeries<
                                                              _ChartData,
                                                              String>>[
                                                            BarSeries<
                                                                _ChartData,
                                                                String>(
                                                                dataSource: statusOk
                                                                    ? data
                                                                    : [],
                                                                xValueMapper: (
                                                                    _ChartData data,
                                                                    _) => data.x,
                                                                yValueMapper: (
                                                                    _ChartData data,
                                                                    _) => data.y,
                                                                name: 'Gold',
                                                                color: Colors
                                                                    .white)
                                                          ]),
                                                    ),
                                                  ),
                                                ],
                                              ),),
                                          ),
                                        ),
                                      ))
                                    ]).value as Widget,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              final value = snapshot.data;
              if(value['status'] == 'successful'){
                statusOk = true;
                completionPercentage = double.parse(value['completionPercentage'].toString());
                complete = value['complete'];
                incomplete = value['incomplete'];
                List depts = value['departments'] as List;
                List usrs = value['users'] as List;
                List mandatory = value['mandatoryCompletion'] as List;
                List averageTimes = value['averages'] as List;
                departments.clear();
                data.clear();
                for(int x = 0; x < depts.length; x++){
                  departments.add(new Department(name: depts[x]['name'], complete: depts[x]['complete'], incomplete: depts[x]['incomplete'], completionPercentage: depts[x]['percentage'].toDouble()));
                  data.add(_ChartData(depts[x]['name'].toString().toUpperCase().substring(0, 3), depts[x]['incomplete'].toDouble(),));
                }
                //replaced
                users.clear();
                for(int x = 0; x < usrs.length; x++){
                  users.add(new User(name: usrs[x]['name'], completionPercentage: usrs[x]['completionPercentage'].toDouble()));
                }
                mandatoryCompletion.clear();
                for(int x = 0; x < mandatory.length; x++){
                  mandatoryCompletion.add(DataRow(cells: [DataCell(Text(mandatory[x]['name'].toString())), DataCell(Text(mandatory[x]['deadline'].toString())), DataCell(Text(mandatory[x]['over'].toString()))]));
                }
                averages.clear();
                for(int x = 0; x < averageTimes.length; x++) {
                  averages.add(new ChecklistAverage(name: averageTimes[x]['checklist'], average: averageTimes[x]['average'].toString()));
                }
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
                                if(allTime == true){
                                  reportingData = getReportingData(allTime, false, new DateTime(0), new PickerDateRange(new DateTime(0), new DateTime(0)), context);
                                } else {
                                  reportingData = getReportingData(allTime, wantRange, selectedDay, selectedRange, context);
                                }
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
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            'ALL TIME',
                                            style: TextStyle(color: Colors.white)
                                        ),
                                        Checkbox(
                                            activeColor: Colors.black,
                                            value: allTime,
                                            onChanged: (value){
                                              setState((){
                                                allTime = value!;
                                                if(allTime == true){
                                                  reportingData = getReportingData(allTime, false, new DateTime(0), new PickerDateRange(new DateTime(0), new DateTime(0)), context);
                                                }
                                              });
                                            }
                                        ),
                                      ],
                                    ),
                                  ]
                              )
                          ),
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
                                                          child: InkWell(
                                                            hoverColor: Colors.transparent,
                                                            onTap: (){
                                                              Navigator.of(context).pushNamed('/complete');
                                                            },
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
                                                      ),
                                                      ResponsiveRowColumnItem(
                                                        child: Expanded(
                                                          child: InkWell(
                                                            hoverColor: Colors.transparent,
                                                            onTap: () {
                                                              Navigator.of(context).pushNamed('/incomplete');
                                                            },
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
                                                      ),
                                                      ResponsiveRowColumnItem(
                                                        child: Expanded(
                                                          child: InkWell(
                                                            hoverColor: Colors.transparent,
                                                            onTap: () {
                                                              Navigator.of(context).pushNamed('/areasofconcern');
                                                            },
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
                                                                padding: const EdgeInsets.only(left: 8, right: 8),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                    Text(
                                                                      'AREAS OF CONCERN',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.white
                                                                      ),
                                                                    ),
                                                                    statusOk ? ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: departments.length >= 3 ? 3 : departments.length,
                                                                        itemBuilder: (context, index){
                                                                          Department department = departments[index] as Department;
                                                                          return Container(
                                                                            width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.125, valueWhen: [Condition.smallerThan(name: "LAPTOP", value:
                                                                            MediaQuery.of(context).size.width * 0.7)]).value!,
                                                                            child: LinearPercentIndicator(
                                                                              animation: true,
                                                                              lineHeight: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.01, valueWhen: [Condition.smallerThan(name: "LAPTOP", value:
                                                                              MediaQuery.of(context).size.height * 0.025)]).value!,
                                                                              animationDuration: 2000,
                                                                              percent: department.completionPercentage == -1 ? 0.0 : (department.completionPercentage! / 100),
                                                                              leading: Padding(
                                                                                padding: const EdgeInsets.only(right: 5),
                                                                                child: Text(department.name!, style: TextStyle(color: Colors.white)),
                                                                              ),
                                                                              trailing: Padding(
                                                                                padding: const EdgeInsets.only(left: 5.0),
                                                                                child: Text(department.completionPercentage == -1 ? '0%' : department.completionPercentage.toString() + '%', style: TextStyle(color: Colors.white)),
                                                                              ),
                                                                              linearStrokeCap: LinearStrokeCap.roundAll,
                                                                              progressColor: Colors.redAccent,
                                                                            ),
                                                                          );
                                                                        }
                                                                    ) : Container(
                                                                        child: Text('N/A')
                                                                    ),
                                                                  ],
                                                                ),
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
                                                                  InkWell(
                                                                    hoverColor: Colors.transparent,
                                                                    onTap: () {
                                                                      Navigator.of(context).pushNamed('/usercompletion');
                                                                    },
                                                                    child: Container(
                                                                        height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.41,
                                                                            valueWhen: [Condition.largerThan(name: TABLET, value: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.31,
                                                                                valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.25)]).value!)]).value!,
                                                                        width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.9,
                                                                            valueWhen: [Condition.largerThan(name: TABLET, value:
                                                                            ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.21,
                                                                                valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.25)]).value!)]).value!,
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.white12),
                                                                        margin: EdgeInsets.all(ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.025,
                                                                            valueWhen: [Condition.largerThan(name: TABLET, value: 0.0)]).value!,),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Text('USER COMPLETION %', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                            statusOk ? ListView.builder(
                                                                              shrinkWrap: true,
                                                                              itemCount: users.length >= 3 ? 3 : users.length,
                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                User user = users[index] as User;
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
                                                                                      Text(user.name!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                                                                        fontSize: ResponsiveValue(context, defaultValue: 10.0,
                                                                                            valueWhen: [
                                                                                              Condition.equals(name: MOBILE, value: 12.0),
                                                                                              Condition.equals(name: TABLET, value: 14.0),
                                                                                              Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.017),
                                                                                              Condition.equals(name: DESKTOP, value: 16.0),]).value!,)),
                                                                                      LinearPercentIndicator(
                                                                                        animation: true,
                                                                                        lineHeight: ResponsiveValue(context, defaultValue: 18.0, valueWhen:
                                                                                        [Condition.largerThan(name: TABLET, value: MediaQuery.of(context).size.height * 0.01)]).value!,
                                                                                        animationDuration: 2000,
                                                                                        percent: user.completionPercentage! / 100,
                                                                                        trailing: Padding(
                                                                                          padding: const EdgeInsets.only(left: 5),
                                                                                          child: Text(user.completionPercentage.toString() + '%', style: TextStyle(color: Colors.white)),
                                                                                        ),
                                                                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                                                                        progressColor: Colors.greenAccent,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ) : Container(
                                                                                child: Text('N/A')
                                                                            ),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                  InkWell(
                                                                    hoverColor: Colors.transparent,
                                                                    onTap: () {
                                                                      Navigator.of(context).pushNamed('/mandatoryincompletion');
                                                                    },
                                                                    child: Container(
                                                                        height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.41,
                                                                            valueWhen: [Condition.largerThan(name: TABLET, value: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.31,
                                                                                valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.25)]).value!)]).value!,
                                                                        width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.9,
                                                                            valueWhen: [Condition.largerThan(name: TABLET, value:
                                                                            ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.21,
                                                                                valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.25)]).value!)]).value!,
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.white12),
                                                                        margin: EdgeInsets.all(ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.025,
                                                                            valueWhen: [Condition.largerThan(name: TABLET, value: 0.0)]).value!,),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Text('MANDATORY INCOMPLETION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                            statusOk ? Container(
                                                                              child: DataTable(
                                                                                headingRowHeight: MediaQuery.of(context).size.height * 0.05,
                                                                                dataRowHeight: MediaQuery.of(context).size.height * 0.04,
                                                                                columnSpacing: 22.5,
                                                                                dataTextStyle: TextStyle(
                                                                                  fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.0159,
                                                                                      valueWhen: [
                                                                                        Condition.equals(name: MOBILE, value: MediaQuery.of(context).size.height * 0.0159),
                                                                                        Condition.equals(name: TABLET, value: MediaQuery.of(context).size.height * 0.0159),
                                                                                        Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.0159),
                                                                                        Condition.equals(name: DESKTOP, value: MediaQuery.of(context).size.height * 0.0159),]).value!,
                                                                                  color: Colors.amber,
                                                                                ),
                                                                                horizontalMargin: 0,
                                                                                columns: [
                                                                                  DataColumn(label: Text('Name', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.0159))),
                                                                                  DataColumn(label: Text('Date', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.0159))),
                                                                                  DataColumn(tooltip: 'Days overdue',label: Text('Over', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.0159)))],
                                                                                rows: mandatoryCompletion,
                                                                              ),
                                                                            ) : Container(
                                                                              child: Text('N/A'),
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ),
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
                                                                  height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.41,
                                                                      valueWhen: [Condition.largerThan(name: TABLET, value: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.31,
                                                                          valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.25)]).value!)]).value!,
                                                                  width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.9,
                                                                      valueWhen: [Condition.largerThan(name: TABLET, value:
                                                                      ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.21,
                                                                          valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.25)]).value!)]).value!,
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.white12),
                                                                  margin: EdgeInsets.all(ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.025,
                                                                      valueWhen: [Condition.largerThan(name: TABLET, value: 0.0)]).value!,),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        'COMPLETION PERCENTAGE',
                                                                        style: new TextStyle(fontWeight: FontWeight.bold,
                                                                            color: Colors.white
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.all(15),
                                                                        child: new CircularPercentIndicator(
                                                                          radius: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.275,
                                                                              valueWhen: [Condition.equals(name: MOBILE, value: MediaQuery.of(context).size.height * 0.30),
                                                                                Condition.equals(name: TABLET, value: MediaQuery.of(context).size.height * 0.30),
                                                                                Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.17),
                                                                                Condition.equals(name: DESKTOP, value: MediaQuery.of(context).size.height * 0.2),]).value!,
                                                                          lineWidth: 20.0,
                                                                          animation: true,
                                                                          percent: statusOk ? completionPercentage / 100 : 0.0,
                                                                          center: new Text(
                                                                            statusOk ? completionPercentage.toString() + '%' : 'N/A',
                                                                            style:
                                                                            new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                                                                          ),
                                                                          circularStrokeCap: CircularStrokeCap.round,
                                                                          progressColor: Colors.greenAccent,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  hoverColor: Colors.transparent,
                                                                  onTap: () {
                                                                    Navigator.of(context).pushNamed('/averagecompletiontimes');
                                                                  },
                                                                  child: Container(
                                                                      height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.41,
                                                                          valueWhen: [Condition.largerThan(name: TABLET, value: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.31,
                                                                              valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.height * 0.25)]).value!)]).value!,
                                                                      width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.9,
                                                                          valueWhen: [Condition.largerThan(name: TABLET, value:
                                                                          ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.21,
                                                                              valueWhen: [Condition.equals(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.25)]).value!)]).value!,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.white12),
                                                                      margin: EdgeInsets.all(ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.025,
                                                                          valueWhen: [Condition.largerThan(name: TABLET, value: 0.0)]).value!,),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text('AVERAGE COMPLETION TIMES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          statusOk ? Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: ListView.builder(
                                                                                  itemCount: averages.length,
                                                                                  shrinkWrap: true,
                                                                                  itemBuilder: (context, index){
                                                                                    ChecklistAverage checklistAverage = averages[index] as ChecklistAverage;
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Text('${checklistAverage.name} - ${checklistAverage.average}', style: TextStyle(fontSize: 14, color: Colors.white)),
                                                                                    );
                                                                                  }
                                                                              )
                                                                          ) : Container(
                                                                              child: Text('N/A')
                                                                          ),
                                                                        ],
                                                                      )),
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
                                ResponsiveRowColumnItem(
                                  child: ResponsiveValue(context, defaultValue: Container(), valueWhen: [Condition.largerThan(name: TABLET, value:
                                  Container(
                                    child: Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 30, bottom: 30),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black87,
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                  ),
                                                  margin: EdgeInsets.all(10),
                                                  child: SfDateRangePicker(
                                                    initialSelectedRange: selectedRange,
                                                    view: DateRangePickerView.month,
                                                    selectionMode: wantRange ? DateRangePickerSelectionMode.extendableRange : DateRangePickerSelectionMode.single,
                                                    initialSelectedDate: selectedDay,
                                                    confirmText: wantRange ? "RANGE +" : "RANGE -",
                                                    cancelText: "CLEAR",
                                                    onCancel: (){
                                                      selectedRange = new PickerDateRange(DateTime.now(), DateTime.now());
                                                      selectedDay = DateTime.now();
                                                      setState((){
                                                      });
                                                      reportingData = getReportingData(allTime, wantRange, selectedDay, selectedRange, context);
                                                    },
                                                    onSubmit: (value){
                                                      setState((){
                                                        wantRange = !wantRange;
                                                      });
                                                    },
                                                    onSelectionChanged: (value) {
                                                      //replaced
                                                      if(wantRange){
                                                        selectedRange = value.value as PickerDateRange;
                                                        if(selectedRange.startDate != null && selectedRange.endDate != null){
                                                          setState((){});
                                                        }
                                                      } else {
                                                        selectedDay = value.value as DateTime;
                                                        setState((){});
                                                      }
                                                      reportingData = getReportingData(allTime, wantRange, selectedDay, selectedRange, context);
                                                    },
                                                    showActionButtons: true,
                                                    headerStyle: DateRangePickerHeaderStyle(
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    monthCellStyle: DateRangePickerMonthCellStyle(
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    yearCellStyle: DateRangePickerYearCellStyle(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                  ),
                                                  margin: EdgeInsets.all(10),
                                                  child: SfCartesianChart(
                                                      primaryXAxis: CategoryAxis(),
                                                      primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
                                                      tooltipBehavior: _tooltip,
                                                      series: <ChartSeries<_ChartData, String>>[
                                                        BarSeries<_ChartData, String>(
                                                            dataSource: statusOk ? data : [],
                                                            xValueMapper: (_ChartData data, _) => data.x,
                                                            yValueMapper: (_ChartData data, _) => data.y,
                                                            name: 'Gold',
                                                            color: Colors.white)
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),),
                                      ),
                                    ),
                                  ))]).value as Widget,
                                )
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
                                        ),
                                        ),
                                  onPressed: (){
                                    reportingData = getReportingData(allTime, false, selectedDay, selectedRange, context);
                                    setState((){});
                                  }
                              )
                            ],
                          )
                      ),
                    )),
              ],
            ));
          }
        }
    );
  }
}
