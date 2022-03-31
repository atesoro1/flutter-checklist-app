import 'dart:async';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:putts_portal/admin/createchecklistschedule.dart';
import 'package:putts_portal/admin/positionview.dart';
import 'package:putts_portal/admin/reporting/mandatoryincompletion.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:putts_portal/admin/addlisttemplateform.dart';
import 'package:putts_portal/admin/adminlist.dart';
import 'package:putts_portal/logout.dart';
import 'package:putts_portal/admin/adminpeople.dart';
import 'package:putts_portal/admin/admindepartment.dart';
import 'admin/adminsettings.dart';
import 'admin/adminhome.dart';
import 'admin/reporting/areasofconcern.dart';
import 'admin/reporting/averagecompletiontimes.dart';
import 'admin/reporting/complete.dart';
import 'admin/reporting/departmentoverview.dart';
import 'admin/reporting/incomplete.dart';
import 'admin/reporting/usercompletion.dart';
import 'admin/userpermission.dart';
import 'login.dart';
import 'logout.dart';
import 'availablechats.dart';
import 'admin/barcodeView.dart';
import 'admin/completedlistinstanceview.dart';
import 'non-admin/listinstanceview.dart';
import 'admin/listinstanceview.dart';
import 'mobilemessageview.dart' if(dart.library.html) 'webmessageview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'admin/createchecklistschedule.dart';
import 'admin/deletechecklistschedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:putts_portal/firstpagephone.dart' if (dart.library.html) 'package:putts_portal/firstpageweb.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final storage = await SharedPreferences.getInstance();
  // //replaced
  // if(storage.getBool('login') == true || storage.getBool('login') != null){
  //   firstPage = Home();
  // }
  String appId = '';
  if(kIsWeb){
    appId = "1:1043611438037:web:54cd2c7abf6cc4ce8ecb5c";
  } else {
    appId = "1:1043611438037:android:87abcf26dfca18068ecb5c";
  }
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDySCvoZCCkQ7fhTSGMemhM1kKDyjObiuU",
          authDomain: "puttsportalmessaging.firebaseapp.com",
          projectId: "puttsportalmessaging",
          storageBucket: "puttsportalmessaging.appspot.com",
          messagingSenderId: "1043611438037",
          appId: appId,
          measurementId: "G-YH5DYPZF7Q"),
    );
  } catch(e) {
    
  }
  //replaced
  FirebaseMessaging.onBackgroundMessage(MyApp.myBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  static Socket? socket = io('http://' + Login.localhost + ':8080', <String, dynamic>{
    'transports': ['websocket'],
  });
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static String fcmToken = "Getting Firebase Token";
  static Future<void> myBackgroundHandler(RemoteMessage message) async {
    return _showNotification(message);
  }
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future<Widget>? checkLoggedIn;

  static Future _showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    RemoteNotification? data = message.notification;
    Map<String, dynamic> dataValue = message.data;

    AndroidNotification? android = message.notification?.android;
    if(data != null){
      flutterLocalNotificationsPlugin.show(
        0,
        data.title,
        data.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android?.smallIcon,
                setAsGroupSummary: true
            ),
            iOS: const IOSNotificationDetails(
                presentAlert: true,
                presentSound: true
            )
        ),
        payload: 'referenceName',
      );
    }
  }
  static getToken() async {
    String? token = await _firebaseMessaging.getToken();
    fcmToken = token!;
  }
  static Future<dynamic> onSelectNotification(payload) async {
    //implement
  }
  static requestingPermissionsForIOS() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      //replaced
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional) {
      //replaced
    } else {
      //replaced
    }

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  static initFirebase() async {
    await requestingPermissionsForIOS();
    await getToken();

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });
  }
  static Future<Widget> checkLogin(BuildContext context) async {
    final storage = await SharedPreferences.getInstance();
    print('In MyApp FutureBuilder checkLogin');
    if(storage.getBool('login') == true || storage.getBool('login') != null){
      final storage = await SharedPreferences.getInstance();
      Login.sessionId = storage.getString('sessionId');
      Login.userId = storage.getInt('userId');
      int admin = 0;
      if(storage.getBool('admin') == false){
        admin = 0;
      } else {
        admin = 1;
      }
      Login.adminView = admin;
      List userPermissions = [];
      List jobPermissions = [];
      List<String> userTempPermissions = storage.getStringList('userPermissions') as List<String>;
      List<String> jobTempPermissions = storage.getStringList('jobPermissions') as List<String>;
      for(int x = 0; x < userTempPermissions.length; x++){
        userPermissions.add(userTempPermissions[x]);
      }
      for(int x = 0; x < jobTempPermissions.length; x++){
        jobPermissions.add(jobTempPermissions[x]);
      }
      UserPermission.userPermissions = userPermissions;
      UserPermission.jobPermissions = jobPermissions;
      MyApp.socket!.connect();
      MyApp.socket!.onConnect((_) async {
        await MyApp.initFirebase();
        //replaced
        MyApp.socket!.emit('userId', [Login.userId, MyApp.fcmToken]);
      });
      final ipv4 = await Ipify.ipv4();
      Timer.run(() async {
        await Login.getOnNetwork(ipv4).then((value) => {
          if(value == 'successful'){
            Login.onNetwork = true,
          } else if(value == 'no-session'){
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
            ),
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
            }),
          } else {
            Login.onNetwork = false,
          },
          //replaced
        });
      });
      Timer.periodic(const Duration(minutes: 1), (timer) async {
        await Login.getOnNetwork(ipv4).then((value) => {
          if(value == 'successful'){
            Login.onNetwork = true,
          } else if(value == 'no-session'){
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
            ),
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
            }),
          } else {
            Login.onNetwork = false,
          },
        });
      });
      await Login.getUserLocations(ipv4).then((value) {
        Login.locationSet = value;
      });
      return Home();
    } else {
      return Login();
    }
  }
  static ScaffoldFeatureController? sb;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  void didChangeDependencies(){
    MyApp.checkLoggedIn = MyApp.checkLogin(context);
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    try {
      MyApp.sb!.close();
    } catch(e) {
    }
    try {
      sb!.close();
    } catch(e) {
    }
    super.dispose();
  }

  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    return Container(
      constraints: BoxConstraints(minHeight: 600, minWidth: 400),
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'Montserrat',
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextStyle: TextStyle(fontSize: 37.5),
            ),
        ),
        builder: (context, widget) => ResponsiveWrapper.builder(
            ClampingScrollWrapper.builder(context, widget!),
            minWidth: 300,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: 'LAPTOP'),
              ResponsiveBreakpoint.resize(1370, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/completeInstance') {
            final value = settings.arguments as int; // Retrieve the value.
            return MaterialPageRoute(builder: (_) => CompletedListInstanceView(value)); // Pass it to BarPage.
          }
          return null; // Let `onUnknownRoute` handle this behavior.
        },
        title: 'Putts Portal',
        routes: {
          '/': (context) => FutureBuilder<Widget>(future: MyApp.checkLoggedIn, builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                          Text('Loading...',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: MediaQuery.of(context).size.width * 0.02
                              ))
                        ],
                      )
                    ),
                  ));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                print('In FutureBuilder MyApp');
                Widget firstPage = snapshot.data as Widget;
                return firstPage;
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },),
          '/people' : (context) => const AdminPeople(),
          '/list' : (context) => AdminList(),
          '/settings' : (context) => const AdminSettings(),
          '/reports' : (context) => const AdminDepartment(),
          '/add' : (context) => const AddListTemplateForm(),
          '/login': (context) => const Login(),
          '/instance': (context) => Login.adminView == 1 ? AdminListInstanceView() : ListInstanceView(),
          '/message': (context) => const MessageView(),
          '/availableChats': (context) => const AvailableChats(),
          '/position': (context) => const PositionView(),
          '/barcode': (context) => const barcodeView(),
          '/complete': (context) => const Complete(),
          '/incomplete': (context) => const Incomplete(),
          '/areasofconcern': (context) => const AreasOfConcern(),
          '/usercompletion': (context) => const UserCompletion(),
          '/mandatoryincompletion': (context) => const MandatoryIncompletion(),
          '/averagecompletiontimes': (context) => const AverageCompletionTime(),
          '/departmentoverview': (context) => const DepartmentOverview(),
          '/createchecklistschedule': (context) => const CreateChecklistSchedule(),
          '/deletechecklistschedule': (context) => const DeleteChecklistSchedule(),
        },
        debugShowCheckedModeBanner: false,
        ),
    );
  }
}










