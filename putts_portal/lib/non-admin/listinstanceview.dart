import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logout.dart';
import 'listinstanceitem.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:signature/signature.dart';

import '../login.dart';

class ListInstanceView extends StatefulWidget {
  const ListInstanceView({Key? key}) : super(key: key);

  @override
  _ListInstanceViewState createState() => _ListInstanceViewState();
}

class _ListInstanceViewState extends State<ListInstanceView> {

  @override
  void didChangeDependencies(){
    successful = setArgs(context);
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    try {
      sb!.close();
    } catch(e){
      print('no snackbar');
    }
    super.dispose();
  }

  void refresh(){
    setState(() {
    });
  }

  Map? args;
  Future<bool>? successful;
  bool refreshed = false;
  bool setController = false;
  bool setIssueMessageController = false;
  bool signatureCompleted = false;
  bool ownershipTaken = false;
  String owner = 'N/A';
  List<ListInstanceItem> instanceItems = [];
  SignatureController sc = new SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.blue,
  );
  ScaffoldFeatureController? sb;


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: successful,
      builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
          ) {
        print(snapshot.connectionState);
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
            print('hello');
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black87,
                  title: Text("CHECKLIST VIEW"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        bool completed = true;
                        for(int x = 0; x < instanceItems.length; x++){
                          //replaced
                          //replaced
                          //replaced
                          //replaced
                          //replaced
                          //replaced
                          //replaced
                          //replaced
                          switch(instanceItems[x].itemType){
                            case 'yes/no':
                              instanceItems[x].content = '';
                              break;
                            case 'shortResponse':
                              if(instanceItems[x].tc.text != ''){
                                instanceItems[x].content = instanceItems[x].tc.text;
                                instanceItems[x].completed = 1;
                              }
                              break;
                            case 'longResponse':
                              if(instanceItems[x].tc.text != ''){
                                instanceItems[x].content = instanceItems[x].tc.text;
                                instanceItems[x].completed = 1;
                              }
                              break;
                            case 'barcode':
                              if(instanceItems[x].scanResult != null){
                                instanceItems[x].content = instanceItems[x].scanResult!.rawContent;
                                instanceItems[x].completed = 1;
                              }
                              break;
                          }
                          if(instanceItems[x].completed == 0){
                            completed = false;
                          }
                        }
                        try {
                          if(sc.isNotEmpty && completed == true){
                            signatureCompleted = true;
                          } else {
                            signatureCompleted = false;
                          }
                          submitRequest(signatureCompleted, args!['instanceId'], context).then((value) => {
                            if(value == 'instanceFinished'){
                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Checklist completed!'),
                                  action: SnackBarAction(
                                    label: 'okay',
                                    onPressed: () {
                                      // Code to execute.
                                    },
                                  ),
                                ),
                              ),
                              Navigator.of(context).pop(),
                            } else if(value == 'continue'){
                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Items submitted'),
                                  action: SnackBarAction(
                                    label: 'okay',
                                    onPressed: () {
                                      // Code to execute.
                                    },
                                  ),
                                ),
                              ),
                            } else {
                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Checklist could not be completed...'),
                                  action: SnackBarAction(
                                    label: 'okay',
                                    onPressed: () {
                                      // Code to execute.
                                    },
                                  ),
                                ),
                              ),
                            },
                            successful = setArgs(context),
                          });
                        } catch(e){

                        }
                      },
                      child: Text('SUBMIT', style: TextStyle(color: Colors.amber)),
                    ),
                  ],
                ),
                body: Container(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 1),
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
                    child: Container(
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('BELONGS TO: ${owner}', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      ownershipTaken ? Container() : Checkbox(
                                          value: ownershipTaken, onChanged: (value) async {
                                        ownershipTaken = value!;
                                        await setOwnership(args!['instanceId'].toString());
                                        successful = setArgs(context);
                                      }
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: instanceItems.length,
                                      itemBuilder: (context, index) {
                                        double nonLongResponseItem = instanceItems[index].itemName!.length <= 30 ? MediaQuery.of(context).size.height * 0.175 : (instanceItems[index].itemName!.length < 100 && instanceItems[index].itemName!.length > 30 ? MediaQuery.of(context).size.height * 0.275 : MediaQuery.of(context).size.height * 0.325);
                                        double longResponseItem = instanceItems[index].itemName!.length <= 30 ? MediaQuery.of(context).size.height * 0.3 : (instanceItems[index].itemName!.length < 100 && instanceItems[index].itemName!.length > 30 ? MediaQuery.of(context).size.height * 0.45 : MediaQuery.of(context).size.height * 0.5);
                                        return Container(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                  child: Container(
                                                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1, maxHeight: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.4, valueWhen: [Condition.smallerThan(name: TABLET, value: instanceItems[index].itemType != 'longResponse' ? nonLongResponseItem : longResponseItem)]).value!,),
                                                    width: MediaQuery.of(context).size.width * 0.9,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.white.withOpacity(0.25),
                                                          Colors.white.withOpacity(0.1),
                                                        ],
                                                        begin: AlignmentDirectional.topStart,
                                                        end: AlignmentDirectional.bottomEnd,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: Colors.white.withOpacity(0.2),
                                                      ),
                                                    ),
                                                    child: ResponsiveRowColumn(
                                                      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      columnMainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      layout: ResponsiveValue(context, defaultValue: ResponsiveRowColumnType.ROW, valueWhen: [Condition.smallerThan(name: TABLET, value: ResponsiveRowColumnType.COLUMN)]).value!,
                                                      children: [
                                                        ownershipTaken ? ResponsiveRowColumnItem(child: Expanded(flex: 12, child: Padding(
                                                          padding: const EdgeInsets.all(12),
                                                          child: Container(child: Text(instanceItems[index].itemName!, style: TextStyle(color: Colors.black),)),
                                                        ))) : ResponsiveRowColumnItem(child: Container()),
                                                        ownershipTaken ? ResponsiveRowColumnItem(child: Expanded(flex: 10, child: getType(instanceItems[index].itemType!, index))) : ResponsiveRowColumnItem(child: Container()),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.9,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        color: Colors.black87,
                                                      ),
                                                      width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.1, valueWhen: [Condition.smallerThan(name: DESKTOP, value: MediaQuery.of(context).size.width * 0.125), Condition.smallerThan(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.35), Condition.smallerThan(name: MOBILE, value: MediaQuery.of(context).size.width * 0.45), Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.45)]).value!,
                                                      child: TextButton(
                                                          child: Text(
                                                            'CREATE ISSUE +',
                                                            style: TextStyle(color: Colors.amber),
                                                          ),
                                                          onPressed: () {
                                                            showAnimatedDialog(
                                                              context: context,
                                                              barrierDismissible: true,
                                                              builder: (BuildContext context) {
                                                                return StatefulBuilder(
                                                                    builder: (context, setState){
                                                                      return AlertDialog(
                                                                        title: Text('Add Issue?'),
                                                                        content: Container(
                                                                          height: MediaQuery.of(context).size.height * 0.3,
                                                                          width: MediaQuery.of(context).size.width * 0.9,
                                                                          child: Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: TextFormField(
                                                                                  maxLines: 8,
                                                                                  decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                                                                                  controller: instanceItems[index].issueMessageController,
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: Text('Exit'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        if(instanceItems[index].issueMessageController.text == ''){
                                                                                          sb = ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(
                                                                                              content: const Text('Please put in a message!'),
                                                                                              action: SnackBarAction(
                                                                                                label: 'Okay',
                                                                                                onPressed: () {
                                                                                                  // Code to execute.
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        } else {
                                                                                          Navigator.of(context).pop();
                                                                                        }
                                                                                      },
                                                                                      child: Text('Submit'),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                );
                                                              },
                                                              animationType: DialogTransitionType.size,
                                                              curve: Curves.elasticInOut,
                                                            );
                                                          }
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                  signatureCompleted == false && ownershipTaken == true ? Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, bottom: MediaQuery.of(context).size.height * 0.1),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                                  color: Colors.black87,
                                                ),
                                                height: MediaQuery.of(context).size.height * 0.1,
                                                width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.3, valueWhen: [Condition.largerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.2,)]).value!,
                                                child: Center(child: Text(
                                                    "SIGNATURE",
                                                    style: TextStyle(
                                                      color: Colors.amber,
                                                      fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.02, valueWhen: [Condition.largerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.01,)]).value!,
                                                    ))),
                                                padding: EdgeInsets.all(10),
                                              ),
                                              ClipRRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.white.withOpacity(0.25),
                                                          Colors.white.withOpacity(0.1),
                                                        ],
                                                        begin: AlignmentDirectional.topStart,
                                                        end: AlignmentDirectional.bottomEnd,
                                                      ),
                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: Colors.white.withOpacity(0.2),
                                                      ),
                                                    ),
                                                    height: MediaQuery.of(context).size.height * 0.1,
                                                    width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.6, valueWhen: [Condition.largerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.5,)]).value!,
                                                    child: Signature(
                                                      controller: sc,
                                                      width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.6, valueWhen: [Condition.largerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.5,)]).value!,
                                                      height: MediaQuery.of(context).size.height * 0.1,
                                                      backgroundColor: Colors.transparent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) : Container()
                                ],
                              ),
                            ),
                          ],
                        )
                    )
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

  Future<List<ListInstanceItem>> getInstanceItems(String instanceId, BuildContext context) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/instanceItems');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'instanceId': instanceId, 'sessionId': Login.sessionId!}).then((Response? response) => {
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

    List<ListInstanceItem> temp = [];

    for(int x = 0; x < jsonList.length; x++){
      if(jsonList[x]['completed']['data'][0] == 0){
        temp.add(new ListInstanceItem(instanceItemId: jsonList[x]['instanceItemId'], itemName: jsonList[x]['itemName'], itemType: jsonList[x]['itemType'], templateId: jsonList[x]['templateId'], completed: jsonList[x]['completed']['data'][0], instanceId: jsonList[x]['instanceId']));
      }
    }
    //replaced

    return temp;
  }
  Future<void> submitItems() async {
    String? responseBody;
    Response? responses;
    bool anyItems = false;
    var json;
    //replaced
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/submitItems');
    for(int x = 0; x < instanceItems.length; x++){
      //replaced
      //replaced
      //replaced
      //replaced
      //replaced
      //replaced
      //replaced
      //replaced
      if(instanceItems[x].completed == 1){
        anyItems = true;
        try {
          await HttpClientHelper.post(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'location': Login.location, 'instanceItemId': instanceItems[x].instanceItemId.toString(), 'itemType': instanceItems[x].itemType.toString(), 'content': instanceItems[x].content.toString(), 'yesNo': instanceItems[x].yesOrNo.toString(),
            'completed': instanceItems[x].completed.toString(), 'instanceId': instanceItems[x].instanceId.toString(), 'issueMessage': instanceItems[x].issueMessageController.text}).then((Response? response) =>
          {
            responseBody = response!.body,
            json = jsonDecode(responseBody!),
            if(json['status'] == 'error'){
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Could not submit items...'),
                  action: SnackBarAction(
                    label: 'okay',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              ),
            } else if(json['status'] == 'instanceError'){
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Checklist completion error...'),
                  action: SnackBarAction(
                    label: 'okay',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              ),
            }
          });
        } catch (e) {
          sb = ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Error'),
              action: SnackBarAction(
                label: 'okay',
                onPressed: () {
                  // Code to execute.
                },
              ),
            ),
          );
        }
      }
    }
  }
  Future<String> submitRequest(bool signatureCompleted, int instanceId, BuildContext context) async {
    String? responseBody;
    Response? responses;

    var json;

    if(signatureCompleted == false){
      await submitItems();
    }

    if(signatureCompleted == true){
      await submitItems();
      final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/signInstance');
      try {
        await HttpClientHelper.put(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'instance': instanceId.toString()}).then((Response? response) =>
        {
          responseBody = response!.body,
          json = jsonDecode(responseBody!),
        });
      } catch (e) {
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
        return 'error';
      }
      refreshed = false;
      setIssueMessageController = false;
      setController = false;
      refresh();
      return json['status'];
    } else {
      refreshed = false;
      setIssueMessageController = false;
      setController = false;
      refresh();
      return 'continue';
    }

  }
  Future<String> setOwnership(String instanceId) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/ownership/update/');
    try {
      await HttpClientHelper.put(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'instanceId': instanceId, 'userId': Login.userId.toString(), 'timeStarted': DateTime.now().toString(), 'onNetwork': Login.onNetwork.toString(), 'location': Login.location}).then((Response? response) => {
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
  Future<String> getOwnership(String instanceId) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/ownership?id=' + instanceId);
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}).then((Response? response) => {
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
      return '-1:N/A';
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
    return json['ownership'];
  }
  Future<void> scan(int index) async {
    try {
      final result = await BarcodeScanner.scan(
          options: ScanOptions(
              useCamera: -1
          )
      );
      setState(() {
        instanceItems[index].scanResult = result;
      });
    } on PlatformException catch(e){
      setState(() {
        instanceItems[index].scanResult = ScanResult(
          type: ResultType.Error,
        );
      });
    }
  }
  Widget getType(String type, int index){
    switch(type){
      case 'yes/no':
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.1,
          child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    color: Colors.greenAccent,
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: ResponsiveValue(context, defaultValue: 120.0, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.445)]).value!,
                  child: Center(
                    child: RadioListTile(
                      value: true,
                      groupValue: instanceItems[index].yesOrNo,
                      onChanged: (value) {
                        setState(() {
                          instanceItems[index].completed = 1;
                          instanceItems[index].yesOrNo = value as bool?;
                        });
                      },
                      title: Text("YES", style: TextStyle(color: Colors.white),),
                      activeColor: Colors.white,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Colors.redAccent,
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: ResponsiveValue(context, defaultValue: 120.0, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.445)]).value!,
                  child: Center(
                    child: RadioListTile(
                      value: false,
                      groupValue: instanceItems[index].yesOrNo,
                      onChanged: (value) {
                        setState(() {
                          instanceItems[index].completed = 1;
                          instanceItems[index].yesOrNo = value as bool?;
                        });
                      },
                      title: Text("NO", style: TextStyle(color: Colors.white),),
                      activeColor: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      case 'longResponse':
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
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
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            maxLines: 30,
                            controller: instanceItems[index].tc,
                            decoration: InputDecoration.collapsed(hintText: 'Enter Text Here', hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      case 'shortResponse':
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.1,
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
              alignment: Alignment.center,
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Center(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              minLines: 1,
                              controller: instanceItems[index].tc,
                              decoration: InputDecoration.collapsed(hintText: 'Enter Text Here', hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      case 'barcode':
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    scan(index);
                  },
                  icon: Icon(Icons.camera),
                ),
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }
  Future<bool> setArgs(BuildContext context) async {
    try {
      args = ModalRoute.of(context)!.settings.arguments as Map;
      List<String> list = [];
      args!.forEach((key, value) {
        list.add('${key}:${value}');
      });
      final storage = await SharedPreferences.getInstance();
      storage.setStringList('page_state_arguments', list);
    } catch(e){
      final storage = await SharedPreferences.getInstance();
      Map tempMap = new Map();
      List<String> list = storage.getStringList('page_state_arguments')!;
      for(int x = 0; x < list.length; x++){
        if(x == 0){
          tempMap['${list[x].split(':')[0]}'] = int.parse(list[x].split(':')[1]);
        } else {
          tempMap['${list[x].split(':')[0]}'] = list[x].split(':')[1];
        }
      }
      args = tempMap;
    }
    await getOwnership(args!['instanceId'].toString()).then((value) async {
      print(value);
      if(value == '-1:N/A'){
        ownershipTaken = false;
        owner = 'N/A';
      } else {
        ownershipTaken = true;
        owner = value.split(':')[1];
        instanceItems = await getInstanceItems(args!['instanceId'].toString(), context);
      }
      setState(() {

      });
    });
    return true;
  }
}
