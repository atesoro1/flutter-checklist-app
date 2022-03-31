import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:putts_portal/admin/checklistdata.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import '../logout.dart';

class CompletedListInstanceView extends StatefulWidget {
  final int instanceId;
  const CompletedListInstanceView(this.instanceId, {Key? key}) : super(key: key);

  @override
  _CompletedListInstanceViewState createState() => _CompletedListInstanceViewState();
}

class _CompletedListInstanceViewState extends State<CompletedListInstanceView> {

  @override
  void dispose(){
    try {
      sb!.close();
    } catch(e){
      print('no snackbar');
    }
    super.dispose();
  }

  List items = [];
  bool refreshed = false;
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    getItems(context, widget.instanceId).then((value){
      items = value;
      if(refreshed == false){
        refreshed = true;
        setState((){});
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("CHECKLIST DATA"),
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
        width: double.infinity,
        child: Center(
          child: ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ChecklistData checklist =  items[index] as ChecklistData;
                Widget? item;
                if(checklist.itemType! == 'yes/no'){
                  item = Container(
                    margin: EdgeInsets.all(8.0),
                    constraints: ResponsiveValue(context, defaultValue: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1,), valueWhen: [Condition.smallerThan(name: "LAPTOP", value: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4,))]).value!,
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
                    child: ResponsiveRowColumn(
                      layout: ResponsiveValue(context, defaultValue: ResponsiveRowColumnType.ROW, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: ResponsiveRowColumnType.COLUMN)]).value!,
                      rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                      columnMainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Name: " + checklist.itemName!, style: TextStyle(color: Colors.white))))),
                        ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Type: " + checklist.itemType!, style: TextStyle(color: Colors.white))))),
                        ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Yes/No: " + checklist.yesAndNo!, style: TextStyle(color: Colors.white))))),
                        checklist.issue == null ? ResponsiveRowColumnItem(child: Container()) : ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Issue: " + checklist.issue!, softWrap: true, style: TextStyle(color: Colors.white))))),
                      ],
                    ),
                  );
                } else if(checklist.itemType! == 'shortResponse'){
                    item = Container(
                      margin: EdgeInsets.all(8.0),
                      constraints: ResponsiveValue(context, defaultValue: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1,), valueWhen: [Condition.smallerThan(name: "LAPTOP", value: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1, maxHeight: MediaQuery.of(context).size.height * 0.5,))]).value!,
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
                      child: ResponsiveRowColumn(
                        layout: ResponsiveValue(context, defaultValue: ResponsiveRowColumnType.ROW, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: ResponsiveRowColumnType.COLUMN)]).value!,
                        rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                        columnMainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Name: " + checklist.itemName!, style: TextStyle(color: Colors.white))))),
                          ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Type: " + checklist.itemType!, style: TextStyle(color: Colors.white))))),
                          ResponsiveRowColumnItem(child: Expanded(flex: 2, child: Center(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("SR: " + checklist.shortResponse!, style: TextStyle(color: Colors.white)),
                          )))),
                          checklist.issue == null ? ResponsiveRowColumnItem(child: Container()) : ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Issue: " + checklist.issue!, softWrap: true, style: TextStyle(color: Colors.white))))),
                        ],
                      ),
                    );
                } else if(checklist.itemType! == 'longResponse'){
                    item = Container(
                      margin: EdgeInsets.all(8.0),
                      constraints: ResponsiveValue(context, defaultValue: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1,), valueWhen: [Condition.smallerThan(name: "LAPTOP", value: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1, maxHeight: MediaQuery.of(context).size.height * 1,))]).value!,
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
                      child: ResponsiveRowColumn(
                        layout: ResponsiveValue(context, defaultValue: ResponsiveRowColumnType.ROW, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: ResponsiveRowColumnType.COLUMN)]).value!,
                        rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                        columnMainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Name: " + checklist.itemName!, style: TextStyle(color: Colors.white))))),
                          ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Type: " + checklist.itemType!, style: TextStyle(color: Colors.white))))),
                          ResponsiveRowColumnItem(child: Expanded(flex: 2, child: Center(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("LR: " + checklist.longResponse!, style: TextStyle(color: Colors.white)),
                          )))),
                          checklist.issue == null ? ResponsiveRowColumnItem(child: Container()) : ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Issue: " + checklist.issue!, softWrap: true, style: TextStyle(color: Colors.white))))),
                        ],
                      ),
                    );
                } else {
                  item = Container(
                    margin: EdgeInsets.all(8.0),
                    constraints: ResponsiveValue(context, defaultValue: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1,), valueWhen: [Condition.smallerThan(name: "LAPTOP", value: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4,))]).value!,
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
                    child: ResponsiveRowColumn(
                      layout: ResponsiveValue(context, defaultValue: ResponsiveRowColumnType.ROW, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: ResponsiveRowColumnType.COLUMN)]).value!,
                      rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                      columnMainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Name: " + checklist.itemName!, style: TextStyle(color: Colors.white))))),
                        ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Type: " + checklist.itemType!, style: TextStyle(color: Colors.white))))),
                        ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Scanned: " + checklist.scanned!, style: TextStyle(color: Colors.white))))),
                        checklist.issue == null ? ResponsiveRowColumnItem(child: Container()) : ResponsiveRowColumnItem(child: Expanded(child: Center(child: Text("Issue: " + checklist.issue!, softWrap: true, style: TextStyle(color: Colors.white))))),
                      ],
                    ),
                  );
                }
                return item;
              }
          ),
        ),
      ),
    );
  }

  Future<List> getItems(BuildContext context, int id) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/instance/items/report?id=' + id.toString());
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
    //replaced
    List instanceItems = [];
    for(int x = 0; x < (json['data'] as List).length; x++){
      instanceItems.add(new ChecklistData(json['data'][x]['itemName'], json['data'][x]['itemType'], json['data'][x]['yes/no'] == null ? null : (json['data'][x]['yes/no'] == 1 ? 'Yes' : 'No'), json['data'][x]['shortResponse'] == null ? '' : json['data'][x]['shortResponse'], json['data'][x]['longResponse'] == null ? '' : json['data'][x]['longResponse'], json['data'][x]['scanned'] == null ? '0' : json['data'][x]['scanned']['data'][0].toString(), json['data'][x]['issue'] == null ? "No Issues" : json['data'][x]['issue']));
    }
    //replaced
    return instanceItems;
  }
}

