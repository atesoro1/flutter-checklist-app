import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:putts_portal/admin/adminhome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:putts_portal/admin/permission.dart';
import 'package:putts_portal/admin/userpermission.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logout.dart';
import 'Position.dart';
import 'department.dart';
import '../login.dart';

class PositionView extends StatefulWidget {
  const PositionView({Key? key}) : super(key: key);

  @override
  _PositionViewState createState() => _PositionViewState();
}

class _PositionViewState extends State<PositionView> {

  @override
  void didChangeDependencies(){
    data = setData(context);
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

  void refresh() {
    setState(() {
    });
  }

  Future<bool>? data;
  Map? args;
  TextEditingController textController = new TextEditingController();
  List positions = [];
  List departments = [];
  List permissions = [];
  bool refreshed = false;
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: data,
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
            Department department = args!['department'] as Department;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black87,
                  title: Text(department.departmentName.toString() + ' Roles'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: [
                    UserPermission.getAllPermissions().contains('add roles') ? IconButton(
                      icon: Icon(Icons.add),
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
                                      title: Text('Add Role', style: TextStyle(color: Colors.white)),
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
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                                controller: textController,
                                                decoration: InputDecoration(
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
                                                  ),
                                                  helperText: "Name",
                                                  suffix: IconButton(
                                                    icon: Icon(Icons.input, color: Colors.amber),
                                                    onPressed: () {
                                                      if(textController.text == ""){
                                                        sb = ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: const Text('Please enter a role!'),
                                                            action: SnackBarAction(
                                                              label: 'okay',
                                                              onPressed: () {
                                                                // Code to execute.
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        Navigator.of(context).pop();
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
                                                                      title: Text('Role permissions', style: TextStyle(color: Colors.white)),
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
                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                          border: Border.all(
                                                                            width: 1.5,
                                                                            color: Colors.black.withOpacity(0.2),
                                                                          ),
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3, maxHeight: MediaQuery.of(context).size.height * 0.5, minWidth: MediaQuery.of(context).size.width * 0.8, maxWidth: MediaQuery.of(context).size.width * 0.8),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            permissions.isEmpty ? Container(child: Text('No permissions', style: TextStyle(color: Colors.white))) : Expanded(
                                                                              child: ListView.builder(
                                                                                  itemCount: permissions.length,
                                                                                  itemBuilder: (context, index){
                                                                                    Permission permission = permissions[index] as Permission;
                                                                                    return Row(
                                                                                      children: [
                                                                                        Checkbox(
                                                                                          activeColor: Colors.green,
                                                                                          side: BorderSide(color: Colors.white),
                                                                                          value: permission.permissionSelected,
                                                                                          onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
                                                                                            setState(() {
                                                                                              permission.permissionSelected = value!;
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                        Expanded(child: Text(permission.permissionName!, style: TextStyle(color: Colors.white))),
                                                                                      ],
                                                                                    );
                                                                                    return Container();
                                                                                  }
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                TextButton(
                                                                                    child: Text('EXIT', style: TextStyle(color: Colors.amber)),
                                                                                    onPressed: () {
                                                                                      textController.text = '';
                                                                                      Navigator.of(context).pop();
                                                                                    }
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: (){
                                                                                    bool anySelected = false;
                                                                                    for(var x = 0; x < permissions.length; x++){
                                                                                      Permission temp = permissions[x] as Permission;
                                                                                      if(temp.permissionSelected == true){
                                                                                        anySelected =  true;
                                                                                      }
                                                                                    }
                                                                                    if(anySelected == true || permissions.isEmpty){
                                                                                      Navigator.of(context).pop();
                                                                                      showAnimatedDialog(
                                                                                        context: context,
                                                                                        barrierDismissible: true,
                                                                                        builder: (BuildContext context) {
                                                                                          return StatefulBuilder(
                                                                                              builder: (context, setState){
                                                                                                return AlertDialog(
                                                                                                  backgroundColor: Colors.black45,
                                                                                                  title: Text('Add role?', style: TextStyle(color: Colors.white)),
                                                                                                  content: Container(
                                                                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                                                                    height: MediaQuery.of(context).size.height * 0.15,
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
                                                                                                    child: Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                      children: [
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            TextButton(
                                                                                                              onPressed: () {
                                                                                                                textController.text = '';
                                                                                                                Navigator.of(context).pop();
                                                                                                              },
                                                                                                              child: Text(
                                                                                                                  "CANCEL",
                                                                                                                  style: TextStyle(color: Colors.amber)
                                                                                                              ),
                                                                                                            ),
                                                                                                            TextButton(
                                                                                                              onPressed: (){
                                                                                                                if(textController.text != ""){
                                                                                                                  addPosition(textController.text, permissions, department.departmentId, context).then((value) => {
                                                                                                                    if(value == 'successful'){
                                                                                                                      data = setData(context),
                                                                                                                      sb = ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                        SnackBar(
                                                                                                                          content: const Text('Successfully added role'),
                                                                                                                          action: SnackBarAction(
                                                                                                                            label: 'okay',
                                                                                                                            onPressed: () {
                                                                                                                              // Code to execute.
                                                                                                                            },
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    } else if(value == 'network'){
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
                                                                                                                    } else {
                                                                                                                      sb = ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                        SnackBar(
                                                                                                                          content: const Text('Could not create role!'),
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
                                                                                                                textController.text = '';
                                                                                                                Navigator.of(context).pop();
                                                                                                              },
                                                                                                              child: Text(
                                                                                                                  "SUBMIT",
                                                                                                                  style: TextStyle(color: Colors.amber)
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
                                                                                    } else {
                                                                                      sb = ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(
                                                                                          content: const Text('Please select permissions!'),
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
                                                                                  child: Text('CONTINUE', style: TextStyle(color: Colors.amber)),
                                                                                )
                                                                              ],
                                                                            )
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
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    textController.text = '';
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "EXIT",
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
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      positions.isEmpty ? Container(child: Text('No positions'),) : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: positions.length,
                            itemBuilder: (context, index){
                              Position position = positions[index];
                              return Column(
                                children: [
                                  Container(
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
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: ListTile(
                                      leading: Text(position.positionName, style: TextStyle(color: Colors.white)),
                                      trailing: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.amber),
                                          onPressed: (){
                                            deleteRole(position.positionId, context).then((value) => {
                                              if(value == 'successful'){
                                                data = setData(context),
                                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text('Successfully deleted role!'),
                                                    action: SnackBarAction(
                                                      label: 'okay',
                                                      onPressed: () {
                                                        // Code to execute.
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              } else if(value == 'exists'){
                                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text('Role doesn\'t exists'),
                                                    action: SnackBarAction(
                                                      label: 'okay',
                                                      onPressed: () {
                                                        // Code to execute.
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              } else if(value == 'error') {
                                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text('Can\'t delete, user has role!'),
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
                                                    content: const Text('Not on the network!'),
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
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              );
                            }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      }
    );
  }

  Future<bool> setData(BuildContext context) async {
    bool dataSet = false;
    final storage = await SharedPreferences.getInstance();
    try {
      args = ModalRoute.of(context)!.settings.arguments as Map;
      Department department = args!['department'] as Department;
      storage.setString('page_state_arguments', '${department.departmentId}:${department.departmentName}');
      await getPositions(department.departmentId, context).then((value) => {
        positions = value,
        getDepartments(context).then((value) => {
          departments = value,
          getPermissions(context).then((value) => {
            permissions = value,
            setState((){}),
          })
        })
      });
      dataSet = true;
    } catch(e) {
      Map temp = new Map();
      String? arguments = storage.getString('page_state_arguments');
      int id = int.parse(arguments!.split(':')[0]);
      String name = arguments.split(':')[1];
      Department department = new Department(departmentId: id, departmentName: name);
      temp['department'] = department;
      args = temp;
      print('getting positions');
      await getPositions(id, context).then((value) => {
        positions = value,
        getDepartments(context).then((value) => {
          departments = value,
          getPermissions(context).then((value) => {
            permissions = value,
            setState((){}),
          })
        })
      });
    }
    dataSet = true;
    return dataSet;
  }
  Future<String> deleteRole(int positionId, BuildContext context) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/position/delete');
    try {
      await HttpClientHelper.delete(url, timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'id': positionId.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
  Future<List> getPermissions(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List temp = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/permission/');
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
    List permissions = json['permissions'];
    for(var x = 0; x < permissions.length; x++){
      temp.add(new Permission(permissionId: permissions[x]['permissionID'], permissionName: permissions[x]['permissionDescription'], permissionSelected: false));
    }

    return temp;
  }
  Future<List> getPositions(int departmentId, BuildContext context) async {
    String? responseBody;
    Response? responses;

    List temp = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/position/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'departmentId': departmentId.toString(), 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    List positions = json['positions'];
    for(var x = 0; x < positions.length; x++){
      temp.add(new Position(positionName: positions[x]['positionName'], positionId: positions[x]['positionID']));
    }

    return temp;
  }
  Future<String> addPosition(String positionName, List permissions, int departmentId, BuildContext context) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/position/add/');

    String tempPermissions = '';
    String finalPermissions = '';

    for(var x = 0; x < permissions.length; x++){
      Permission temp = permissions[x];
      if(temp.permissionSelected == true){
        tempPermissions += temp.permissionId.toString();
        if(x != permissions.length - 1){
          tempPermissions += ', ';
        }
      }
    }

    finalPermissions = tempPermissions.substring(0, tempPermissions.length - 2);


    try {
      await HttpClientHelper.post(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'positionName': positionName, 'departmentId': departmentId.toString(), 'permissions': finalPermissions, 'onNetwork': Login.onNetwork.toString()}).then((Response? response) => {
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
