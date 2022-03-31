import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:putts_portal/admin/userpermission.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logout.dart';
import 'department.dart';
import '../login.dart';

class AdminDepartment extends StatefulWidget {
  const AdminDepartment({Key? key}) : super(key: key);

  @override
  State<AdminDepartment> createState() => _AdminDepartmentState();
}



class _AdminDepartmentState extends State<AdminDepartment> {

  @override
  void dispose(){
    try {
      sb!.close();
    } catch(e){
      print('no snackbar');
    }
    super.dispose();
  }

  void refresh() {
    setState(() {
    });
  }

  List departments = [];
  bool refreshed = false;
  TextEditingController textController = new TextEditingController();
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    ZoomDrawer.of(context)!.close();

    getDepartments(context).then((value) => {
      departments = value,
      if(refreshed == false){
        refreshed = true,
        refresh(),
      },
    });



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
            ),
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
          ),
        actions: [
          UserPermission.getAllPermissions().contains('add department') ? IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: StatefulBuilder(
                        builder: (context, setState){
                          return AlertDialog(
                            backgroundColor: Colors.black45,
                            title: Text('Add Department?', style: TextStyle(color: Colors.white)),
                            content: Container(
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
                                alignment: Alignment.center,
                                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3, maxHeight: MediaQuery.of(context).size.height * 0.3, minWidth: MediaQuery.of(context).size.width * 0.7, maxWidth: MediaQuery.of(context).size.width * 0.7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                             helperText: "Name",
                                            helperStyle: TextStyle(color: Colors.white),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.white,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.amber,
                                              ),
                                            )
                                        ),
                                        controller: textController,
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
                                              "EXIT",
                                              style: TextStyle(color: Colors.amber),
                                            ),
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              if(textController.text != ""){
                                                addDepartment(textController.text, context).then((value) => {
                                                  if(value == 'successful'){
                                                    refreshed = false,
                                                    refresh(),
                                                    Navigator.of(context).pop(),
                                                    sb = ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text("Successfully added department!"),
                                                        action: SnackBarAction(
                                                          label: 'okay',
                                                          onPressed: () {
                                                            // Code to execute.
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  } else if(value == 'exists'){
                                                    Navigator.of(context).pop(),
                                                    sb = ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('Department Already Exists!'),
                                                        action: SnackBarAction(
                                                          label: 'okay',
                                                          onPressed: () {
                                                            // Code to execute.
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  } else if(value == 'error'){
                                                    Navigator.of(context).pop(),
                                                    sb = ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('Could not create department'),
                                                        action: SnackBarAction(
                                                          label: 'okay',
                                                          onPressed: () {
                                                            // Code to execute.
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  } else {
                                                    Navigator.of(context).pop(),
                                                    sb = ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('Not on the network'),
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
                                              } else {
                                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text('Enter a name!'),
                                                    action: SnackBarAction(
                                                      label: 'okay',
                                                      onPressed: () {
                                                        // Code to execute.
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                              textController.text = '';
                                            },
                                            child: Text(
                                                "SUBMIT",
                                              style: TextStyle(color: Colors.amber),
                                            ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                        }
                    ),
                  );
                },
                animationType: DialogTransitionType.size,
                curve: Curves.fastOutSlowIn,
              );
            },
          ) : Container(),
        ],
        title: Text('DEPARTMENTS'),
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
            departments.isEmpty ? Container(child: Text('No Departments')) : Expanded(
              child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: departments.length,
                    itemBuilder: (context, index){
                      Department currentDepartment = departments[index] as Department;
                      return Container(
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 9,
                              child: InkWell(
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
                                      height: 70,
                                      width: MediaQuery.of(context).size.width * .9,
                                      child: ListTile(
                                        title: Text(
                                          currentDepartment.departmentName,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(Icons.delete, color: Colors.amber,),
                                            onPressed: (){
                                              deleteDepartment(currentDepartment.departmentId, context).then((value) => {
                                                if(value == 'successful'){
                                                  refreshed = false,
                                                  refresh(),
                                                  sb = ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: const Text("Successfully deleted department"),
                                                      action: SnackBarAction(
                                                        label: 'okay',
                                                        onPressed: () {
                                                          // Code to execute.
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                } else if(value == 'error'){
                                                  sb = ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: const Text("There are still positions for this department!"),
                                                      action: SnackBarAction(
                                                        label: 'okay',
                                                        onPressed: () {
                                                          // Code to execute.
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                } else if(value == 'exists'){
                                                  SnackBar(
                                                    content: const Text("Department does not exist!"),
                                                    action: SnackBarAction(
                                                      label: 'okay',
                                                      onPressed: () {
                                                        // Code to execute.
                                                      },
                                                    ),
                                                  ),
                                                } else {
                                                  sb = ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: const Text("Not on the network!"),
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
                                            }
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  Navigator.pushNamed(context, '/position', arguments: {'department': currentDepartment});
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List> getDepartments(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List temp = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/department/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    List departments = json['departments'];
    for(var x = 0; x < departments.length; x++){
      temp.add(new Department(departmentId: departments[x]['departmentId'], departmentName: departments[x]['departmentName']));
    }

    return temp;
  }

  Future<String> deleteDepartment(int departmentId, BuildContext context) async {
    String? responseBody;
    Response? responses;

    List temp = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/department/delete/');
    try {
      await HttpClientHelper.delete(url, timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'id': departmentId.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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

  Future<String> addDepartment(String name, BuildContext context) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/department/add/');
    try {
      await HttpClientHelper.post(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'name': name, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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