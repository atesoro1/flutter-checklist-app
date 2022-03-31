import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:putts_portal/admin/admintriggers.dart';
import 'package:putts_portal/admin/customelevatedbutton.dart';
import 'package:http/http.dart';
import 'package:putts_portal/person.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logout.dart';
import 'adminlist.dart';
import 'barcode.dart';
import 'department.dart';
import 'adminlisttemplate.dart';
import '../login.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height / 4.25);
    var firstControlPoint = new Offset(size.width / 4, size.height / 3);
    var firstEndPoint = new Offset(size.width / 2, size.height / 3 - 60);
    var secondControlPoint =
    new Offset(size.width - (size.width / 4), size.height / 4 - 65);
    var secondEndPoint = new Offset(size.width, size.height / 3 - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
  
}


class AddListTemplateForm extends StatefulWidget {
  const AddListTemplateForm({Key? key}) : super(key: key);

  @override
  _AddListTemplateFormState createState() => _AddListTemplateFormState();
}

class _AddListTemplateFormState extends State<AddListTemplateForm> {

  @override
  void dispose(){
    try {
      sb!.close();
    } catch(e){
      print('no snackbar');
    }
    super.dispose();
  }

  Object? itemType;
  Object? barcodeId;
  int count = 0;
  int _index = 0;
  bool temp = false;
  final formKeyName = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final itemController = TextEditingController();
  String name = '';
  String category = '';
  List items = [];
  List<Map> nameTypeBarcodeTriggerIdList = [];
  Object? itemSelected = -1;
  Object? val = -1;
  String buttonText1 = 'NEXT';
  String buttonText2 = 'BACK';
  List departments = [];
  List triggers = [];
  List users = [];
  List barcodes = [];
  bool refreshed = false;
  bool showUsers = false;
  bool mandatory = false;
  ScaffoldFeatureController? sb;

  void refresh(){
    setState(() {
    });
  }

  Future<List> getUsers() async {
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
    List temp = [];
    try {
      for(int x = 0; x < jsonList.length; x++){
        temp.add(new Person(userId: jsonList[x]['userId'], first: jsonList[x]['firstName'], last: jsonList[x]['lastName']));
      }
    }catch(e){

    }

    return temp;
  }

  Future<List> getBarcodes() async {
    String? responseBody;
    Response? responses;

    List temp = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/barcode/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!, 'onNetwork': Login.onNetwork.toString(), 'location': Login.location!}).then((Response? response) => {
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
    List barcodes = json['barcodes'];
    for(var x = 0; x < barcodes.length; x++){
      temp.add(new Barcode(barcodeValue: barcodes[x]['barcodeValue'], barcodeId: barcodes[x]['barcodeId']));
    }
    //replaced

    return temp;
  }

  Future<String> _submit(List temp, BuildContext context) async {
    String? responseBody;
    Response? responses;


    print(nameTypeBarcodeTriggerIdList);
    //replaced
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/create/');
    try {
      await HttpClientHelper.post(url,
          timeLimit: Duration(seconds: 5),
          headers: {'sessionId': Login.sessionId!},
          body: {
            'name': name,
            'department': val.toString(),
            'items': jsonEncode(nameTypeBarcodeTriggerIdList),
            'location': Login.location!,
            'mandatory': mandatory.toString(),
            'onNetwork': Login.onNetwork.toString(),
          }
      ).then((Response? response) =>
      {
        responseBody = response!.body,
        responses = response
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
    var json = jsonDecode(responseBody!);
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

  Future<List> getDepartments() async {
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


  @override
  Widget build(BuildContext context) {

    getDepartments().then((value) => {
      departments = value,
      getBarcodes().then((value) => {
        barcodes = value,
        getUsers().then((value) => {
          users = value,
          if(refreshed == false){
            refreshed = true,
            refresh(),
          },
        }),
      })
    });

    String? hint = 'Enter Text Here';
    // final list = ModalRoute
    //     .of(context)!
    //     .settings
    //     .arguments as List;
    // bool on = true;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text("CREATE TEMPLATE"),
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
          height: double.infinity,
          child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                ClipPath(
                  clipper: CustomClip(),
                  child: Container(
                    color: Colors.amber,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            'MANDATORY',
                          style: TextStyle(color: Colors.white),
                        ),
                        Checkbox(
                          activeColor: Colors.black,
                          value: mandatory,
                          onChanged: (value){
                            setState(() {
                              mandatory = value!;
                            });
                          },
                        ),
                      ]
                    ),

                    Expanded(
                      child: Scrollbar(
                        radius: Radius.circular(50),
                        interactive: true,
                        isAlwaysShown: true,
                        thickness: 10,
                        child: SingleChildScrollView(
                          child: Stepper(
                            controlsBuilder: (BuildContext context,
                                {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
                              return SizedBox(
                                height: 75,
                                child: Row(
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.black87,
                                        elevation: 20,
                                      ),
                                      onPressed: onStepContinue,
                                      child: Text(
                                        buttonText1,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.black87,
                                        elevation: 20,
                                      ),
                                      onPressed: onStepCancel,
                                      child: Text(
                                        buttonText2,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            currentStep: _index,
                            onStepCancel: () {
                              if (_index > 0) {
                                setState(() {
                                  _index -= 1;
                                  switch (_index) {
                                    case 0:
                                      buttonText1 = 'NEXT';
                                      formKeyName.currentState!.save();
                                      break;
                                    case 1:
                                      buttonText1 = 'NEXT';
                                      break;
                                    case 2:
                                      buttonText1 = 'NEXT';
                                      break;
                                    case 3:
                                      buttonText1 = 'NEXT';
                                      break;
                                    case 4:
                                      buttonText1 = 'NEXT';
                                      break;
                                    default:
                                      break;
                                  }
                                });
                              }
                            },
                            onStepContinue: () {
                              bool moveIndex = true;
                              setState(() {
                                switch (_index) {
                                  case 0:
                                    if(nameController.text == ""){
                                      moveIndex = false;
                                      sb = ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Please enter a name for the template!'),
                                          action: SnackBarAction(
                                            label: 'okay',
                                            onPressed: () {
                                              // Code to execute.
                                            },
                                          ),
                                        ),
                                      );
                                      break;
                                    } else {
                                      moveIndex = true;
                                      name = nameController.text;
                                      buttonText1 = 'NEXT';
                                      formKeyName.currentState!.save();
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      break;
                                    }
                                  case 1:
                                    if(val == -1){
                                      moveIndex = false;
                                      sb = ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Please choose a department!'),
                                          action: SnackBarAction(
                                            label: 'okay',
                                            onPressed: () {
                                              // Code to execute.
                                            },
                                          ),
                                        ),
                                      );
                                      break;
                                    } else {
                                      moveIndex = true;
                                      buttonText1 = 'NEXT';
                                      break;
                                    }
                                  case 2:
                                    if(items.isEmpty){
                                      moveIndex = false;
                                      sb = ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Templates must have items!'),
                                          action: SnackBarAction(
                                            label: 'okay',
                                            onPressed: () {
                                              // Code to execute.
                                            },
                                          ),
                                        ),
                                      );
                                      break;
                                    } else {
                                      moveIndex = true;
                                      buttonText1 = 'NEXT';
                                      FocusScope.of(context).unfocus();
                                      break;
                                    }
                                  case 3:
                                    moveIndex = true;
                                    buttonText1 = 'SUBMIT';
                                    break;
                                  case 4:
                                    buttonText1 = 'SUBMIT';
                                    List temp = [];
                                    for(CustomElevatedButton item in items){
                                      temp.add(item.name);
                                    }
                                    items.clear();
                                    _submit(temp, context).then((value) => {
                                      if(value == 'successful'){
                                        Navigator.of(context).pop(),
                                        WidgetsBinding.instance!.addPostFrameCallback((_) => {
                                          sb = ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Successfully created template!'),
                                              action: SnackBarAction(
                                                label: 'okay',
                                                onPressed: () {
                                                  // Code to execute.
                                                },
                                              ),
                                            ),
                                          ),
                                        }),
                                      } else if(value == 'nameError'){
                                        sb = ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Please choose a different name!'),
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
                                            content: const Text('Could not create template, not on the network!'),
                                            action: SnackBarAction(
                                              label: 'okay',
                                              onPressed: () {
                                                // Code to execute.
                                              },
                                            ),
                                          ),
                                        ),
                                      } else {
                                        Navigator.pop(context),
                                        WidgetsBinding.instance!.addPostFrameCallback((_) => {
                                          sb = ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Could not add template...'),
                                              action: SnackBarAction(
                                                label: 'okay',
                                                onPressed: () {
                                                  // Code to execute.
                                                },
                                              ),
                                            ),
                                          ),
                                        }),
                                      }
                                    });
                                    break;
                                  default:
                                    break;
                                }
                              });
                              if (_index >= 0 && _index < 4) {
                                setState(() {
                                  if(moveIndex == true){
                                    _index += 1;
                                  }
                                });
                              }
                            },
                            steps: <Step>[
                              Step(
                                title: const Text(
                                  'NAME',
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2
                                  ),
                                ),
                                content: Container(
                                  child: Form(
                                    key: formKeyName,
                                    child: Container(
                                      child: TextFormField(
                                        maxLength: 50,
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              color: Colors.white
                                          ),
                                          hintText: hint,
                                          labelText: 'List Name',
                                          contentPadding: EdgeInsets.only(
                                              right: 10, top: 10, bottom: 10),
                                        ),
                                        onSaved: (value) {

                                        },
                                        controller: nameController,

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Step(
                                title: const Text(
                                  'DEPARTMENT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2
                                  ),
                                ),
                                content: Container(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: departments.length,
                                      itemBuilder: (context, index){
                                        Department department = departments[index] as Department;
                                        return RadioListTile(
                                          value: department.departmentName,
                                          groupValue: val,
                                          onChanged: (value) {
                                            setState(() {
                                              val = value;
                                            });
                                          },
                                          title: Text(department.departmentName),
                                          subtitle: Text("caption/subtext"),
                                          activeColor: Colors.white,
                                        );
                                      }
                                  )

                                ),
                              ),
                              Step(
                                title: Text(
                                  'ITEMS',
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2
                                  ),
                                ),
                                content: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 100,
                                    maxWidth: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                                controller: itemController,
                                                decoration: InputDecoration(
                                                  helperText: 'Item'
                                                ),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 0
                                                ),
                                                maxLines: 1,
                                                maxLength: 150,
                                                maxLengthEnforcement: MaxLengthEnforcement
                                                    .enforced
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black87,
                                            ),
                                            onPressed: () async {
                                              await showAnimatedDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Scaffold(
                                                      backgroundColor: Colors.transparent,
                                                      body: StatefulBuilder(
                                                        builder: (context, setState){
                                                          return AlertDialog(
                                                            backgroundColor: Colors.black45,
                                                            title: Text('Type?', style: TextStyle(color: Colors.white)),
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
                                                              ),
                                                              height: MediaQuery.of(context).size.height * 0.5,
                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      color: Colors.white24,
                                                                      child: ListView(
                                                                        shrinkWrap: true,
                                                                        children: [
                                                                          RadioListTile(
                                                                            value: 'yes/no',
                                                                            groupValue: itemType,
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                itemType = value;
                                                                              });
                                                                            },
                                                                            title: Text("Yes/No", style: TextStyle(color: Colors.white)),
                                                                            activeColor: Colors.green,
                                                                          ),
                                                                          RadioListTile(
                                                                            value: 'longResponse',
                                                                            groupValue: itemType,
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                itemType = value;
                                                                              });
                                                                            },
                                                                            title: Text("Long Response", style: TextStyle(color: Colors.white)),
                                                                            activeColor: Colors.green,
                                                                          ),
                                                                          RadioListTile(
                                                                            value: 'barcode',
                                                                            groupValue: itemType,
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                itemType = value;
                                                                              });
                                                                            },
                                                                            title: Text("Barcode", style: TextStyle(color: Colors.white)),
                                                                            activeColor: Colors.green,
                                                                          ),
                                                                          RadioListTile(
                                                                            value: 'shortResponse',
                                                                            groupValue: itemType,
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                itemType = value;
                                                                              });
                                                                            },
                                                                            title: Text("Short Response", style: TextStyle(color: Colors.white)),
                                                                            activeColor: Colors.green,
                                                                          ),
                                                                        ],
                                                                      ),
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
                                                                          child: Text('exit'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            if(itemType != 'barcode'){
                                                                              CustomElevatedButton temp = new CustomElevatedButton(
                                                                                col: count,
                                                                                name: itemController.text,
                                                                                type: itemType,
                                                                                nameTypeBarcodeTriggerIdList: nameTypeBarcodeTriggerIdList,
                                                                              );
                                                                              temp.onPressed = () {
                                                                                items.removeWhere((item) =>
                                                                                item.name == temp.name
                                                                                );
                                                                                List<Map> tempList = [];
                                                                                for(var x = 0; x < nameTypeBarcodeTriggerIdList.length; x++){
                                                                                  if(nameTypeBarcodeTriggerIdList[x]['name'] != temp.name){
                                                                                    tempList.add(nameTypeBarcodeTriggerIdList[x]);
                                                                                  }
                                                                                }
                                                                                nameTypeBarcodeTriggerIdList = tempList;
                                                                                refreshed = false;
                                                                                refresh();
                                                                              };
                                                                              items.add(temp);
                                                                              Map mapTemp = new Map();
                                                                              mapTemp['name'] = temp.name;
                                                                              mapTemp['type'] = temp.type;
                                                                              mapTemp['barcodeId'] = -1;
                                                                              mapTemp['triggerIds'] = '';
                                                                              nameTypeBarcodeTriggerIdList.add(mapTemp);
                                                                              count++;
                                                                              itemController.clear();
                                                                              refreshed = false;
                                                                              refresh();
                                                                              Navigator.of(context).pop();
                                                                            } else {
                                                                              Navigator.of(context).pop();
                                                                              showAnimatedDialog(
                                                                                context: context,
                                                                                barrierDismissible: true,
                                                                                builder: (BuildContext context) {
                                                                                  return StatefulBuilder(
                                                                                      builder: (context, setState){
                                                                                        return AlertDialog(
                                                                                          backgroundColor: Colors.black45,
                                                                                          title: Text('Barcode?', style: TextStyle(color: Colors.white)),
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
                                                                                            ),
                                                                                            alignment: Alignment.center,
                                                                                            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3, maxHeight: MediaQuery.of(context).size.height * 0.3, minWidth: MediaQuery.of(context).size.width * 0.8, maxWidth: MediaQuery.of(context).size.width * 0.8),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Scrollbar(
                                                                                                    radius: Radius.circular(50),
                                                                                                    thickness: 10,
                                                                                                    child: ListView.builder(
                                                                                                        itemCount: barcodes.length,
                                                                                                        shrinkWrap: true,
                                                                                                        itemBuilder: (context, index){
                                                                                                          Barcode barcode = barcodes[index] as Barcode;
                                                                                                          return RadioListTile(
                                                                                                            tileColor: Colors.white24,
                                                                                                            value: barcode.barcodeId as Object,
                                                                                                            groupValue: barcodeId,
                                                                                                            onChanged: (value) {
                                                                                                              setState(() {
                                                                                                                barcodeId = value;
                                                                                                              });
                                                                                                            },
                                                                                                            title: Text(barcode.barcodeValue!, style: TextStyle(color: Colors.white)),
                                                                                                            activeColor: Colors.green,
                                                                                                          );
                                                                                                        }
                                                                                                    ),
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
                                                                                                        CustomElevatedButton temp = new CustomElevatedButton(
                                                                                                          col: count,
                                                                                                          name: itemController.text,
                                                                                                          type: itemType,
                                                                                                          nameTypeBarcodeTriggerIdList: nameTypeBarcodeTriggerIdList,
                                                                                                        );
                                                                                                        temp.onPressed = () {
                                                                                                          items.removeWhere((item) =>
                                                                                                          item.name == temp.name
                                                                                                          );
                                                                                                          List<Map> tempList = [];
                                                                                                          for(var x = 0; x < nameTypeBarcodeTriggerIdList.length; x++){
                                                                                                            if(nameTypeBarcodeTriggerIdList[x]['name'] != temp.name){
                                                                                                              tempList.add(nameTypeBarcodeTriggerIdList[x]);
                                                                                                            }
                                                                                                          }
                                                                                                          nameTypeBarcodeTriggerIdList = tempList;
                                                                                                          refreshed = false;
                                                                                                          refresh();
                                                                                                        };
                                                                                                        items.add(temp);
                                                                                                        Map mapTemp = new Map();
                                                                                                        mapTemp['name'] = temp.name;
                                                                                                        mapTemp['type'] = temp.type;
                                                                                                        mapTemp['barcodeId'] = barcodeId;
                                                                                                        mapTemp['triggerIds'] = '';
                                                                                                        nameTypeBarcodeTriggerIdList.add(mapTemp);
                                                                                                        count++;
                                                                                                        itemController.clear();
                                                                                                        refreshed = false;
                                                                                                        refresh();
                                                                                                        Navigator.of(context).pop();
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
                                                                            }
                                                                          },
                                                                          child: Text('submit'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      ),
                                                      );
                                                  }
                                              );
                                            },
                                            child: Icon(
                                              Icons.add,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: items.length,
                                          itemBuilder: (context, index) {
                                            return items[index];
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Step(
                                title: Text(
                                  'TRIGGERS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 2
                                  ),
                                ),
                                content: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('ADD TRIGGER', style: TextStyle(color: Colors.black)),
                                        IconButton(
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
                                                          title: Text('Which Items?', style: TextStyle(color: Colors.white)),
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
                                                            height: MediaQuery.of(context).size.height * 0.5,
                                                            width: MediaQuery.of(context).size.width * 0.8,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Container(
                                                                    color: Colors.white24,
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: nameTypeBarcodeTriggerIdList.length,
                                                                        itemBuilder: (context, index){
                                                                          return RadioListTile(
                                                                            activeColor: Colors.green,
                                                                            title: Text(
                                                                                nameTypeBarcodeTriggerIdList[index]['name'],
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                            value: nameTypeBarcodeTriggerIdList[index]['name'] as Object,
                                                                            groupValue: itemSelected,
                                                                            onChanged: (value) {
                                                                              setState((){
                                                                                itemSelected = value;
                                                                              });
                                                                            },
                                                                          );
                                                                        }
                                                                    ),
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
                                                                        'Exit'
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () {
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
                                                                                        title: Text('Who would you like it to alert?', style: TextStyle(color: Colors.white)),
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
                                                                                          height: MediaQuery.of(context).size.height * 0.5,
                                                                                          width: MediaQuery.of(context).size.width * 0.8,
                                                                                          child: Column(
                                                                                            children: [
                                                                                              users.isEmpty ? Container(child: Text('NO ONE')) : Expanded(
                                                                                                child: Container(
                                                                                                  color: Colors.white24,
                                                                                                  child: ListView.builder(
                                                                                                      shrinkWrap: true,
                                                                                                      itemCount: users.length,
                                                                                                      itemBuilder: (context, index){
                                                                                                        Person user = users[index] as Person;
                                                                                                        return Container(
                                                                                                          height: MediaQuery.of(context).size.height * 0.10,
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                flex: 7,
                                                                                                                child: Container(
                                                                                                                  child: Text(
                                                                                                                      '${user.first} ${user.last}',
                                                                                                                    style: TextStyle(color: Colors.white)
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Expanded(
                                                                                                                flex: 1,
                                                                                                                child: Container(
                                                                                                                  width: MediaQuery.of(context).size.width * 0.1,
                                                                                                                  child: Checkbox(
                                                                                                                    side: BorderSide(color: Colors.white),
                                                                                                                    activeColor: Colors.green,
                                                                                                                      value: user.selected,
                                                                                                                      onChanged: (value) {
                                                                                                                        setState((){
                                                                                                                          user.selected = value!;
                                                                                                                        });
                                                                                                                      }
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        );
                                                                                                      }
                                                                                                  ),
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
                                                                                                        'Exit'
                                                                                                    ),
                                                                                                  ),
                                                                                                  TextButton(
                                                                                                    onPressed: () {
                                                                                                      String temp = '';
                                                                                                      String names = '';
                                                                                                      String title = '';
                                                                                                      for(int x = 0; x < users.length; x++){
                                                                                                        Person user = users[x] as Person;
                                                                                                        if(user.selected == true && temp == ''){
                                                                                                          temp += user.userId.toString();
                                                                                                          names += user.first;
                                                                                                        } else if(user.selected == true && temp != ''){
                                                                                                          temp += ', ';
                                                                                                          temp += user.userId.toString();
                                                                                                          names += ', ';
                                                                                                          names += user.first;
                                                                                                        }
                                                                                                      }
                                                                                                      //replaced
                                                                                                      for(int x = 0; x < nameTypeBarcodeTriggerIdList.length; x++){
                                                                                                        if(nameTypeBarcodeTriggerIdList[x]['name'] == itemSelected as String){
                                                                                                          if(nameTypeBarcodeTriggerIdList[x]['triggerIds'] == ''){
                                                                                                            nameTypeBarcodeTriggerIdList[x]['triggerIds'] = temp;
                                                                                                            title = nameTypeBarcodeTriggerIdList[x]['name'];
                                                                                                            triggers.add(new Trigger(title: title, names: names));
                                                                                                          } else {
                                                                                                            sb = ScaffoldMessenger.of(context).showSnackBar(
                                                                                                              SnackBar(
                                                                                                                content: const Text('The trigger for this item already exists!'),
                                                                                                                action: SnackBarAction(
                                                                                                                  label: 'okay',
                                                                                                                  onPressed: () {

                                                                                                                  },
                                                                                                                ),
                                                                                                              ),
                                                                                                            );
                                                                                                          }
                                                                                                        }
                                                                                                      }

                                                                                                      itemSelected = -1;
                                                                                                      refreshed = false;
                                                                                                      refresh();
                                                                                                      Navigator.of(context).pop();
                                                                                                    },
                                                                                                    child: Text(
                                                                                                        'Submit'
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                    );
                                                                                  }
                                                                              ),
                                                                            );
                                                                          },
                                                                          animationType: DialogTransitionType.size,
                                                                          curve: Curves.elasticInOut,
                                                                        );
                                                                      },
                                                                      child: Text(
                                                                          'Continue'
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        );
                                                      }
                                                  ),
                                                );
                                              },
                                              animationType: DialogTransitionType.size,
                                              curve: Curves.elasticInOut,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.add, color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                        itemCount: triggers.length,
                                        primary: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index){
                                          Trigger trigger = triggers[index] as Trigger;
                                          return Column(
                                            children: [
                                              Text(
                                                'Item Name: ' + trigger.title!
                                              ),
                                              Text(
                                                'Trigger Attached To: ' + trigger.names!
                                              ),
                                            ],
                                          );
                                        }
                                    ),
                                  ],
                                ),
                              ),
                              Step(
                                title: Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2
                                  ),
                                ),
                                content: Container(
                                  constraints: BoxConstraints(minWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width, maxWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width, minHeight: 100),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Text('Name: ${name}'),
                                            SizedBox(height: 20,),
                                            Text('Category: ${val}'),
                                            SizedBox(height: 20,),
                                            Text('Items: '),
                                            SizedBox(height: 10,),
                                            Container(

                                              child: SizedBox(
                                                width: 300,
                                                child: Container(
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: items.length,
                                                      itemBuilder: (context, index) {
                                                        return Container(
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                              items[index].name),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 50,),
                                    ],
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
              ]
          ),
        ),
      ),
    );
  }
}
