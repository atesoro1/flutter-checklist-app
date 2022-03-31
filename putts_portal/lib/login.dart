import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:putts_portal/admin/userpermission.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logout.dart';
import 'main.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dart_ipify/dart_ipify.dart';

//final localhost = '10.0.2.2';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static final localhost = '192.168.1.217';
  static String? sessionId;
  static int? userId;
  static int? adminView;
  static String? location;
  static List<String> locationSet = [];
  static bool onNetwork = true;
  static Future<List<String>> getUserLocations(String ip) async {
    String? responseBody;
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/location/user/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'userId': Login.userId.toString()}).then((Response? response) => {
        responseBody = response!.body
      });
    } catch(e){
      return [];
    }
    var json = jsonDecode(responseBody!);

    if(json['status'] == 'successful'){
      Login.location = json['locations'][0];
      List<String> temp = [];
      for(var x = 0; x < json['locations'].length; x++){
        temp.add(json['locations'][x]);
      }
      return temp;
    } else {
      Login.getCurrentLocation(ip).then((value) {
        Login.location = value;
      });
      List<String> temp = [];
      return temp;
    }
  }

  static Future<String> getCurrentLocation(String ip) async {
    String? responseBody;
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/location/current/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'ip': ip}).then((Response? response) => {
        responseBody = response!.body
      });
    } catch(e){
      return 'N/A';
    }
    var json = jsonDecode(responseBody!);

    return json['location'];
  }


  static Future<String> getOnNetwork(String ip) async {
    String? responseBody;
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/location/network/');
    try {
      await HttpClientHelper.get(url, headers: {'ip': ip, 'sessionId': Login.sessionId!}).then((Response? response) => {
        responseBody = response!.body
      });
    } catch(e){
      //replaced
      return 'error';
    }
    var json = jsonDecode(responseBody!);

    return json['status'];
  }


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Future<String> _login(LoginData data) async {
    String? responseBody;
    Response? responses;

    var username = data.name;
    var password = md5.convert(utf8.encode(data.password));

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/account/login/');
    try {
      await HttpClientHelper.post(url, body: {'username': username.toString(), 'password': password.toString()}, timeLimit: Duration(seconds: 5)).then((Response? response) => {
        responseBody = response!.body,
        responses = response
      });

    } catch(e){
      return 'Could not connect to server';
    }
    // var js = jsonDecode();
      var json = jsonDecode(responseBody!);
      if(json['status'] == 'successful'){
        final storage = await SharedPreferences.getInstance();
        storage.setBool('login', true);
        storage.setBool('loggingIn', true);
        Login.sessionId = json['sessionId'];
        storage.setString('sessionId', Login.sessionId!);
        Login.userId = json['userId'];
        storage.setInt('userId', Login.userId!);
        Login.adminView = json['adminView'];
        if(Login.adminView == 0){
          storage.setBool('admin', false);
        } else {
          storage.setBool('admin', true);
        }
        List<String> userPermissions = [];
        UserPermission.userPermissions = json['userPermissions'];
        for(int x = 0; x < UserPermission.userPermissions.length; x++){
          userPermissions.add(UserPermission.userPermissions[x]);
        }
        storage.setStringList('userPermissions', userPermissions);
        List<String> jobPermissions = [];
        UserPermission.jobPermissions = json['jobPermissions'];
        for(int x = 0; x < UserPermission.jobPermissions.length; x++){
          jobPermissions.add(UserPermission.jobPermissions[x]);
        }
        storage.setStringList('jobPermissions', jobPermissions);
        MyApp.socket!.connect();
        MyApp.socket!.onConnect((_) async {
          await MyApp.initFirebase();
          //replaced
          MyApp.socket!.emit('userId', [Login.userId, MyApp.fcmToken]);
        });
        final ipv4 = await Ipify.ipv4();
        // Timer.run(() async {
        //   await Login.getOnNetwork(ipv4).then((value) => {
        //     if(value == 'successful'){
        //       Login.onNetwork = true,
        //     } else if(value == 'no-session'){
        //       sb = ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: const Text('Invalid Session, logging out...'),
        //           action: SnackBarAction(
        //             label: 'okay',
        //             onPressed: () {
        //               // Code to execute.
        //             },
        //           ),
        //         ),
        //       ),
        //     Timer(Duration(seconds: 3), () {
        //       Logout.logout().then((value) async {
        //         if(value == 'successful'){
        //           final storage = await SharedPreferences.getInstance();
        //           storage.remove('login');
        //           storage.remove('sessionId');
        //           storage.remove('userId');
        //           storage.remove('admin');
        //           storage.remove('userPermissions');
        //           storage.remove('jobPermissions');
        //           Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        //         } else {
        //           sb = ScaffoldMessenger.of(context).showSnackBar(
        //             SnackBar(
        //               content: const Text('Could not log you out...'),
        //               action: SnackBarAction(
        //                 label: 'okay',
        //                 onPressed: () {
        //                   // Code to execute.
        //                 },
        //               ),
        //             ),
        //           );
        //         }
        //       });
        //     }),
        //     } else {
        //       Login.onNetwork = false,
        //     },
        //     //replaced
        //   });
        // });
        // Timer.periodic(const Duration(minutes: 1), (timer) async {
        //   await Login.getOnNetwork(ipv4).then((value) => {
        //     if(value == 'successful'){
        //       Login.onNetwork = true,
        //     } else if(value == 'no-session'){
        //       sb = ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: const Text('Invalid Session, logging out...'),
        //           action: SnackBarAction(
        //             label: 'okay',
        //             onPressed: () {
        //               // Code to execute.
        //             },
        //           ),
        //         ),
        //       ),
        //       Timer(Duration(seconds: 3), () {
        //         Logout.logout().then((value) async {
        //           if(value == 'successful'){
        //             final storage = await SharedPreferences.getInstance();
        //             storage.remove('login');
        //             storage.remove('sessionId');
        //             storage.remove('userId');
        //             storage.remove('admin');
        //             storage.remove('userPermissions');
        //             storage.remove('jobPermissions');
        //             Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        //           } else {
        //             sb = ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(
        //                 content: const Text('Could not log you out...'),
        //                 action: SnackBarAction(
        //                   label: 'okay',
        //                   onPressed: () {
        //                     // Code to execute.
        //                   },
        //                 ),
        //               ),
        //             );
        //           }
        //         });
        //       }),
        //     } else {
        //       Login.onNetwork = false,
        //     },
        //     //replaced
        //   });
        // });
        Login.getUserLocations(ipv4).then((value) {
          Login.locationSet = value;
        });
        MyApp.checkLoggedIn = MyApp.checkLogin(context);
        return '';
      } else {
        return 'Error';
      }
  }

  Future<void> checkLoggedIn() async{
    print('In check login');
    final storage = await SharedPreferences.getInstance();
    if((storage.getBool('login') == true || storage.getBool('login') != null)){
      Logout.logout().then((value){
        storage.remove('login');
        storage.remove('sessionId');
        storage.remove('userId');
        storage.remove('admin');
        storage.remove('userPermissions');
        storage.remove('jobPermissions');
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    print('Building Login Widget');
    checkLoggedIn();

    return FlutterLogin(
        userValidator: (username){
          return null;
        },
        hideSignUpButton: true,
        userType: LoginUserType.name,
        onLogin: (data){
          return _login(data);
        },
        onRecoverPassword: (_) => Future(null!),
        logoTag: 'Putts Portal',
        titleTag: 'Best Place',
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
      showDebugButtons: false,
      messages: LoginMessages(
        userHint: 'Pcode',
      ),
      title: 'Putts Portal',
      theme: LoginTheme(
        titleStyle: TextStyle(
          letterSpacing: ResponsiveValue(context, defaultValue: 0.5, valueWhen: [Condition.largerThan(name: TABLET, value: 5.0)]).value,
          color: Colors.white70,
        ),
        cardTheme: CardTheme(
          margin: EdgeInsets.only(top: 40),
          color: Colors.white,
          elevation: 20,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        buttonTheme: LoginButtonTheme(
          backgroundColor: Colors.lightBlue[300],
          highlightColor: Colors.orange,
          elevation: 10,
        ),
        errorColor: Colors.orange,
        pageColorDark: Colors.yellow,
        pageColorLight: Colors.green,
      ), onSignup: (LoginData data) {},
    );
  }
}


