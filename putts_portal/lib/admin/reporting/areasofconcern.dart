import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../login.dart';
import '../../logout.dart';

class AreasOfConcern extends StatefulWidget {
  const AreasOfConcern({Key? key}) : super(key: key);

  @override
  _AreasOfConcernState createState() => _AreasOfConcernState();
}

class _AreasOfConcernState extends State<AreasOfConcern> {

  @override
  void dispose(){
    try {
      sb!.close();
    } catch(e){
      print('no snackbar');
    }
    super.dispose();
  }

  bool allTime = false;
  PickerDateRange? dateRange;
  List departments = [];
  bool show = false;
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AREAS OF CONCERN'),
        backgroundColor: Colors.black87,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(8),
                  color: Colors.black87,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('ALL TIME', style: TextStyle(color: Colors.white)),
                            Checkbox(
                                activeColor: Colors.black,
                                value: allTime,
                                onChanged: (value){
                                  setState(() {
                                    allTime = value!;
                                    departments = [];
                                    if(allTime){
                                      dateRange = PickerDateRange(DateTime(0), DateTime(0));
                                      getReportingAreasOfConcern(allTime, dateRange!, context).then((json) {
                                        try {
                                          if(json['status'] == 'successful'){
                                            departments.clear();
                                            for(int x = 0; x < (json['data'] as List).length; x++){
                                              departments.add(json['data'][x]);
                                            }
                                            if(departments.isEmpty){
                                              show = true;
                                            } else {
                                              show = false;
                                            }
                                            //replaced
                                            setState(() {});
                                          } else {
                                            if(departments.isEmpty){
                                              show = true;
                                            } else {
                                              show = false;
                                            }
                                            setState(() {});
                                            //replaced
                                          }
                                        } catch(e) {
                                          if(departments.isEmpty){
                                            show = true;
                                          } else {
                                            show = false;
                                          }
                                          setState(() {});
                                          //replaced
                                        }
                                      });
                                    }
                                  });
                                }
                            ),
                          ],
                        ),
                      ),
                      allTime ? Container() : Container(
                        child: TextButton(
                          child: Text(
                              'DATE',
                              style: TextStyle(color: Colors.amber)
                          ),
                          onPressed: (){
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context){
                                  return Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1, top: MediaQuery.of(context).size.height * 0.15, bottom: MediaQuery.of(context).size.height * 0.15),
                                      content: Container(
                                        height: MediaQuery.of(context).size.height * 0.6,
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: SfDateRangePicker(
                                          selectionTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                                          rangeTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                                          startRangeSelectionColor: Colors.greenAccent,
                                          endRangeSelectionColor: Colors.greenAccent,
                                          selectionColor: Colors.greenAccent,
                                          rangeSelectionColor: Colors.greenAccent.withOpacity(0.70),
                                          backgroundColor: Colors.black87,
                                          view: DateRangePickerView.month,
                                          monthViewSettings: DateRangePickerMonthViewSettings(
                                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                              textStyle: TextStyle(color: Colors.amber),
                                            ),
                                          ),
                                          yearCellStyle: DateRangePickerYearCellStyle(
                                            textStyle: TextStyle(color: Colors.white),
                                          ),
                                          headerStyle: DateRangePickerHeaderStyle(
                                            textStyle: TextStyle(color: Colors.amber),
                                          ),
                                          monthCellStyle: DateRangePickerMonthCellStyle(
                                            textStyle: TextStyle(color: Colors.white),
                                          ),
                                          selectionMode: DateRangePickerSelectionMode.extendableRange,
                                          confirmText: 'SUBMIT',
                                          cancelText: "CANCEL",
                                          onCancel: (){
                                            Navigator.of(context).pop();
                                          },
                                          onSubmit: (value){
                                            try {
                                              if((value as PickerDateRange).startDate != null && (value as PickerDateRange).endDate != null){
                                                dateRange = value;
                                                getReportingAreasOfConcern(allTime, dateRange!, context).then((json) {
                                                  try {
                                                    if(json['status'] == 'successful'){
                                                      departments.clear();
                                                      for(int x = 0; x < (json['data'] as List).length; x++){
                                                        departments.add(json['data'][x]);
                                                      }
                                                      if(departments.isEmpty){
                                                        show = true;
                                                      } else {
                                                        show = false;
                                                      }
                                                      //replaced
                                                      setState(() {});
                                                      Navigator.of(context).pop();
                                                    } else {
                                                      departments.clear();
                                                      if(departments.isEmpty){
                                                        show = true;
                                                      } else {
                                                        show = false;
                                                      }
                                                      setState(() {});
                                                      //replaced
                                                      Navigator.of(context).pop();
                                                    }
                                                  } catch(e) {
                                                    departments.clear();
                                                    if(departments.isEmpty){
                                                      show = true;
                                                    } else {
                                                      show = false;
                                                    }
                                                    setState(() {});
                                                    //replaced
                                                    Navigator.of(context).pop();
                                                  }
                                                });
                                              } else {
                                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text('Invalid Selection!'),
                                                    action: SnackBarAction(
                                                      label: 'okay',
                                                      onPressed: () {
                                                        // Code to execute.
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch(e){
                                              //replaced
                                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text('Invalid Selection!'),
                                                  action: SnackBarAction(
                                                    label: 'okay',
                                                    onPressed: () {
                                                      // Code to execute.
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          showActionButtons: true,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            allTime == false && dateRange == null ? Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
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
                child: Text('CHOOSE A DATE', style: TextStyle(color: Colors.white)),
              ),
            ) : ResponsiveValue(
                context,
                defaultValue: Container(
                  child: Column(
                    children: [
                      Container(
                          color: Colors.black87,
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(width: MediaQuery.of(context).size.width * 0.3, child: Text("DEPARTMENT", style: TextStyle(color: Colors.white))),
                              Container(width: MediaQuery.of(context).size.width * 0.15, child: Text("COMPLETION\nPERCENTAGE", style: TextStyle(color: Colors.white))),
                              Container(width: MediaQuery.of(context).size.width * 0.15, child: Text("COMPLETE", style: TextStyle(color: Colors.white))),
                              Container(width: MediaQuery.of(context).size.width * 0.15, child: Text("INCOMPLETE", style: TextStyle(color: Colors.white))),
                            ],
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: departments.length,
                            itemBuilder: (context, index){
                              return ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.1,
                                    width: MediaQuery.of(context).size.width * 0.9,
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
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(width: MediaQuery.of(context).size.width * 0.3, child: Text(departments[index]['departmentName'], softWrap: true, style: TextStyle(color: Colors.white))),
                                        Container(width: MediaQuery.of(context).size.width * 0.15, child: Text(departments[index]['percentage'].toString(), style: TextStyle(color: Colors.white))),
                                        Container(width: MediaQuery.of(context).size.width * 0.15, child: Text(departments[index]['complete'].toString(), style: TextStyle(color: Colors.white))),
                                        Container(width: MediaQuery.of(context).size.width * 0.15, child: Text(departments[index]['incomplete'].toString(), style: TextStyle(color: Colors.white))),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                ),
                valueWhen: [Condition.smallerThan(name: TABLET,
                  value: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Row(
                      children: [
                        Container(
                            color: Colors.black87,
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(height: MediaQuery.of(context).size.height * 0.3, child: Text("DEPARTMENT", style: TextStyle(color: Colors.white))),
                                Container(height: MediaQuery.of(context).size.height * 0.1, child: Text("COMPLETION\nPERCENTAGE", style: TextStyle(color: Colors.white))),
                                Container(height: MediaQuery.of(context).size.height * 0.1, child: Text("COMPLETE", style: TextStyle(color: Colors.white))),
                                Container(height: MediaQuery.of(context).size.height * 0.1, child: Text("INCOMPLETE", style: TextStyle(color: Colors.white))),
                              ],
                            )
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: departments.length,
                              itemBuilder: (context, index){
                                return ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.7,
                                      width: MediaQuery.of(context).size.width * 0.375,
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
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(height: MediaQuery.of(context).size.height * 0.3, child: Text(departments[index]['departmentName'], softWrap: true, style: TextStyle(color: Colors.white))),
                                          Container(height: MediaQuery.of(context).size.height * 0.1, child: Text(departments[index]['percentage'].toString(), style: TextStyle(color: Colors.white))),
                                          Container(height: MediaQuery.of(context).size.height * 0.1, child: Text(departments[index]['complete'].toString(), style: TextStyle(color: Colors.white))),
                                          Container(height: MediaQuery.of(context).size.height * 0.1, child: Text(departments[index]['incomplete'].toString(), style: TextStyle(color: Colors.white))),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                )]
            ).value!,
            show ? Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.2),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Text('IS EMPTY', style: TextStyle(color: Colors.white)),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getReportingAreasOfConcern(bool allTime, PickerDateRange range, BuildContext context) async {
    String? responseBody;
    Response? responses;
    //replaced
    if(allTime){
      //replaced
      final Uri url = Uri.parse('http://' + Login.localhost + ':8080/reporting/data/departments/concern?allTime=true&range_start_day=none&range_end_day=none');
      try {
        await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'location': Login.location!, 'sessionId': Login.sessionId!}).then((Response? response) => {
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
      return json;
    } else {
      String range_start_day = range.startDate.toString().split(' ')[0];
      String range_end_day = range.endDate.toString().split(' ')[0];
      final Uri url = Uri.parse('http://' + Login.localhost + ':8080/reporting/data/departments/concern?allTime=false&range_start_day=${range_start_day}&range_end_day=${range_end_day}');
      try {
        await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'location': Login.location!, 'sessionId': Login.sessionId!}).then((Response? response) => {
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
      return json;
    }
  }
}


