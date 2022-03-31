import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:putts_portal/person.dart';
import 'package:putts_portal/admin/userpermission.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import '../logout.dart';
import '../main.dart';
import 'admintriggeritem.dart';
import 'department.dart';
import 'listinstance.dart';
import '../login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'addlisttemplateform.dart';
import 'adminlisttemplate.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'multioccurrenceday.dart';


class AdminList extends StatefulWidget {
  AdminList({Key? key}) : super(key: key);


  @override
  _AdminListState createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {

  @override
  void initState(){
    onNotificationReceived = (notification) async {
      refreshed = false;
      setState(() {
        //replaced
      });
    };
    MyApp.socket!.on('serverNotification', onNotificationReceived!);
    super.initState();
  }

  @override
  void dispose(){
    try {
      MyApp.socket!.off('serverNotification', onNotificationReceived);
      sb!.close();
    } catch(e) {
    }
    super.dispose();
  }

  void refresh() {
    setState(() {
    });
  }

  BuildContext? instanceCtx;
  bool changeName = false;
  String hintText = 'Choose Template';
  bool changeDepartment = false;
  bool changeTrigger = false;
  Object? newDepartment = -1;
  Object? currentDepartment = -1;
  TextEditingController tc = new TextEditingController();
  late BuildContext itemsContext;
  String? chosenType;
  String? chosenTemplate;
  VoidCallback? exit;
  VoidCallback? submit;
  String tempType = '';
  TextEditingController templateNameController = new TextEditingController();
  TimeOfDay? tempTime;
  DateTime? deadline;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? current;
  bool refreshed = false;
  final FloatingSearchBarController controller = FloatingSearchBarController();
  List<Widget> templates = [];
  List<ListInstance> instances = [];
  List<ListInstance> completedInstances = [];
  List departments = [];
  List scheduledTemplates = [];
  List days = [];
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  ScaffoldFeatureController? sb;
  EventHandler? onNotificationReceived;


  @override
  Widget build(BuildContext context) {

    BuildContext ctx = context;

    create(context).then((value) => {
      templates = value,
      showInstances(context).then((value) => {
        instances = value,
        getDepartments(context).then((value) => {
          departments = value,
          if(refreshed == false){
            refreshed = true,
            refresh()
          },
        })
      }),
    });




    ZoomDrawer.of(context)!.close();

        return Scaffold(
          body: PersistentTabView(
            context,
            controller: _controller,
            bottomScreenMargin: MediaQuery.of(context).size.height * 0.05,
            margin: ResponsiveValue(context, defaultValue: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25, right: MediaQuery.of(context).size.width * 0.25), valueWhen:
            [Condition.smallerThan(name: "LAPTOP", value: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),)]).value!,
            screens: _buildScreens(context),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: Colors.black87, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            navBarHeight: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * .075, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.height * .1)]).value!,
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(100.0),
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.easeInBack,
              duration: Duration(milliseconds: 500),
            ),
            navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
          ),
        );
  }

  List<Widget> _buildScreens(BuildContext context) {

    final ctx = context;

    return [
      Container(
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
        //margin: EdgeInsets.all(20),
        child: Scaffold(
          appBar: AppBar(
            title: Text("TEMPLATES"),
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
                ZoomDrawer.of(context)!.toggle();
              }
            ),
            actions: [
              UserPermission.getAllPermissions().contains('add template') ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(ctx, '/add').then((value) => {
                      refreshed = false,
                      refresh()
                    });
                  },
                  icon: Icon(
                    Icons.add_task,
                  )
              ) : Container(),
            ],
          ),
          body: Container(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 1),
            width: MediaQuery.of(context).size.width * 1,
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
            child: ListView.builder(
              itemCount: templates.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var templateItem = templates[index] as ListTemplate;
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.2),
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.25),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 15),
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.025, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.05,)]).value!,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                            )
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                           // borderRadius: BorderRadius.all(Radius.circular(360)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("TEMPLATE NAME: ", style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0125), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.0225)]).value!),),
                                      Text(templateItem.name, style: TextStyle(color: Colors.amber, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0125), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.0225)]).value!),),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("DEPARTMENT: ", style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.01, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0125), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.0225)]).value!)),
                                      Text(templateItem.departmentName, style: TextStyle(color: Colors.amber, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.01, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0125), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.0225)]).value!),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.all(Radius.circular(360)),
                                      ),
                                      child: IconButton(
                                        onPressed: (){
                                          changeName = false;
                                          changeDepartment = false;
                                          changeTrigger = false;
                                          showAnimatedDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                  builder: (context, setState){
                                                    return AlertDialog(
                                                        backgroundColor: Colors.black45,
                                                        title: Text('Update Template', style: TextStyle(color: Colors.white)),
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
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Text('What would you like to change for template', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                                                                      Text(templateItem.name, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.green), textAlign: TextAlign.center),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 10),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Checkbox(
                                                                        activeColor: Colors.green,
                                                                        side: BorderSide(color: Colors.white),
                                                                        value: changeName,
                                                                        onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
                                                                          setState(() {
                                                                            changeName = value!;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text('Name', style: TextStyle(color: Colors.white)),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Checkbox(
                                                                        activeColor: Colors.green,
                                                                        side: BorderSide(color: Colors.white),
                                                                        value: changeDepartment,
                                                                        onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
                                                                          setState(() {
                                                                            changeDepartment = value!;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text('Department', style: TextStyle(color: Colors.white)),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Checkbox(
                                                                        activeColor: Colors.green,
                                                                        side: BorderSide(color: Colors.white),
                                                                        value: changeTrigger,
                                                                        onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
                                                                          setState(() {
                                                                            changeTrigger = value!;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text('Trigger', style: TextStyle(color: Colors.white)),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      changeName = false;
                                                                      changeDepartment = false;
                                                                      changeTrigger = false;
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text('exit'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                      showAnimatedDialog(
                                                                        context: context,
                                                                        barrierDismissible: true,
                                                                        builder: (BuildContext context) {
                                                                          if(!changeName && !changeDepartment && !changeTrigger) {
                                                                            Navigator.of(context).pop();
                                                                          }

                                                                          return StatefulBuilder(
                                                                              builder: (context, setState){
                                                                                return AlertDialog(
                                                                                  backgroundColor: Colors.black45,
                                                                                  title: Text('Update Template', style: TextStyle(color: Colors.white)),
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
                                                                                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3, maxHeight: MediaQuery.of(context).size.height * 0.7, minWidth: MediaQuery.of(context).size.width * 0.3),
                                                                                    child: SingleChildScrollView(
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: <Widget>[
                                                                                          changeName ? createAlertSection('name', templateItem) : Container(width: 0, height: 0,),
                                                                                          changeDepartment ? createAlertSection('department', templateItem) : Container(width: 0, height: 0,),
                                                                                          changeTrigger ? createAlertSection('trigger', templateItem) : Container(width: 0, height: 0,),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              TextButton(
                                                                                                onPressed: exit,
                                                                                                child: Text('exit'),
                                                                                              ),
                                                                                              TextButton(
                                                                                                onPressed: submit,
                                                                                                child: Text('submit'),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                          );
                                                                        },
                                                                        animationType: DialogTransitionType.size,
                                                                        curve: Curves.fastOutSlowIn,
                                                                      );
                                                                    },
                                                                    child: Text('confirm'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                    );
                                                  }
                                              );
                                            },
                                            animationType: DialogTransitionType.slideFromBottomFade,
                                            curve: Curves.fastOutSlowIn,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.all(Radius.circular(360)),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          deleteTemplate(templateItem.name).then((value){
                                            if(value == 'successful'){
                                              refreshed = false;
                                              refresh();
                                            } else if(value == 'instance'){
                                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text('Can\'t delete template, instance exists!'),
                                                  action: SnackBarAction(
                                                    label: 'okay',
                                                    onPressed: () {
                                                      // Code to execute.
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else {
                                              sb = ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text('Could not delete template!'),
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
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                            ]
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      Container(
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
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: (){
                    ZoomDrawer.of(context)!.toggle();
                  },
                ),
                backgroundColor: Colors.black87,
                title: Text("LISTS"),
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
                    Expanded(
                      flex: 15,
                      child: SizedBox(
                        child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            instanceCtx = context;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: instances.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(20),
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
                                        ),
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: ListTile(
                                          horizontalTitleGap: 30,
                                          onTap: () {
                                            Navigator.pushNamed(ctx, '/instance', arguments: {'instanceId': instances[index].instanceId}).then((value) => {
                                              refreshed = false,
                                              refresh(),
                                            });
                                          },
                                          leading: Text(
                                            instances[index].name,
                                            style: TextStyle(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          title: Text(
                                            instances[index].deadline!.year == 0 ? "No Deadline" : instances[index].deadline!.toLocal().toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          trailing: ResponsiveValue(context, defaultValue: Container(width: 0, height: 0), valueWhen: [Condition.largerThan(name: MOBILE, value: Container(child: Icon(Icons.pan_tool, color: Colors.white)))]).value,

                                        ),
                                      ),
                                      SizedBox(height: 20,)
                                    ],
                                  );
                                }
                            );
                          }
                        ),
                        height: MediaQuery.of(context).size.height * 0.8,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          onPressed: () {
                            List<String> templateNames = [];
                            getTemplates().then((value) => {
                              for(int x = 0; x < value.length; x++){
                                templateNames.add(value[x]['templateName']),
                              },

                              showAnimatedDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, void Function(void Function()) setState) {
                                      TimeOfDay selectedTime = TimeOfDay.now();
                                      return AlertDialog(
                                        backgroundColor: Colors.black45,
                                        title: Text('Which Template?', style: TextStyle(color: Colors.white)),
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
                                          height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.3, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.height * 0.5,)]).value!,
                                          width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.5, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.9,)]).value!,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1),
                                                width: MediaQuery.of(context).size.width * 0.4,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: DropdownButtonHideUnderline(
                                                          child: DropdownButton<String>(
                                                            alignment: AlignmentDirectional.centerEnd,
                                                            menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
                                                            dropdownColor: Colors.amber,
                                                            isExpanded: true,
                                                            value: chosenTemplate,
                                                            hint: Text(hintText, style: TextStyle(color: Colors.white)),
                                                            icon: Icon(
                                                              Icons.expand_more,
                                                              color: Colors.white,
                                                            ),
                                                            items: templateNames.map<DropdownMenuItem<String>>((String value) {
                                                              return DropdownMenuItem<String> (
                                                                value: value,
                                                                child: Text(value, style: TextStyle(color: Colors.white)),
                                                              );
                                                            }).toList(),
                                                            onChanged: (String? value) {
                                                              setState(() {
                                                                chosenTemplate = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.4,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    tempTime == null ? Expanded(child: Container(child: Text('Choose Time', style: TextStyle(color: Colors.white)))) : Expanded(child: Container(child: Text('${tempTime!.hour.toString().length == 1 ? "0" + tempTime!.hour.toString() : tempTime!.hour.toString()}:${tempTime!.minute.toString().length == 1 ? "0" + tempTime!.minute.toString() : tempTime!.minute.toString()}', style: TextStyle(color: Colors.white)))),
                                                    Expanded(
                                                      child: Container(
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              padding: EdgeInsets.all(8),
                                                              shape: CircleBorder(),
                                                              primary: Colors.amber,
                                                            ),
                                                            onPressed: () async {
                                                              tempTime = await showTimePicker(
                                                                builder: (context, child){
                                                                  return Container(width: double.infinity, child: child);
                                                                },
                                                                context: context,
                                                                initialTime: selectedTime,
                                                                initialEntryMode: TimePickerEntryMode.input,
                                                              );
                                                              setState((){});
                                                            },
                                                            child: Icon(Icons.more_time),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                        onPressed: (){
                                                          tempTime = null;
                                                          deadline = null;
                                                          chosenTemplate = null;
                                                          hintText = 'Choose Template';
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('Exit'),
                                                    ),
                                                    TextButton(
                                                      onPressed: (){
                                                          final now = new DateTime.now();
                                                          if(tempTime != null && chosenTemplate != null){
                                                            deadline = new DateTime(now.year, now.month, now.day, tempTime!.hour, tempTime!.minute);
                                                            createInstance(chosenTemplate, deadline!).then((value) => {
                                                              if(value == 'successful'){
                                                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                    content: const Text('Successfully created checklist!'),
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
                                                                    content: const Text('Could not create instance!'),
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
                                                                    content: const Text('Could not create checklist, on the network!'),
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
                                                            tempTime = null;
                                                            deadline = null;
                                                            chosenTemplate = null;
                                                            hintText = 'Choose Template';
                                                            refreshed = false;
                                                            refresh();
                                                            Navigator.of(context).pop();
                                                          } else {
                                                            sb = ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: const Text('Please provide a deadline!'),
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
                                                      child: Text('Submit'),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                            )});

                          },
                          child: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
      Container(
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
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.1, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.height * 0.275,)]).value!,
              title: ResponsiveValue(context, defaultValue: Text('COMPLETED'), valueWhen: [Condition.smallerThan(name: TABLET, value: Text(''))]).value!,
              actions: [
                Column(
                  children: [
                    ResponsiveValue(context, defaultValue: Container(), valueWhen: [Condition.smallerThan(name: TABLET, value: Container(child: Text('COMPLETE')),)]).value!,
                    Container(
                      padding: EdgeInsets.all(8),
                      height: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.height * 0.1, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.height * 0.235,)]).value!,
                      width: MediaQuery.of(context).size.width * 0.725,
                      child: ResponsiveRowColumn(
                        layout: ResponsiveValue(context, defaultValue: ResponsiveRowColumnType.ROW, valueWhen: [Condition.smallerThan(name: TABLET, value: ResponsiveRowColumnType.COLUMN)]).value!,
                        columnMainAxisAlignment: MainAxisAlignment.spaceAround,
                        rowMainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ResponsiveRowColumnItem(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.135, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.315)]).value!,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber,
                                    ),
                                    onPressed: () async {
                                      current = DateTime.now();
                                      startDate = await showDatePicker(
                                        context: context,
                                        initialDate: current!,
                                        firstDate: DateTime(2021),
                                        lastDate: DateTime(DateTime.now().year + 1),
                                        locale: const Locale('en'),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: ColorScheme.dark(
                                                primary: Colors.greenAccent,
                                                onPrimary: Colors.white,
                                                surface: Colors.amber,
                                                onSurface: Colors.white,
                                              ),
                                              dialogBackgroundColor:Colors.black87,
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      setState((){});
                                    },
                                    child: Text('Start Date', style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                startDate == null ? Container(width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.135, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.315)]).value!, child: Text('Starting Date')) :
                                Container(width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.135, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.315)]).value!, child: Text(startDate.toString(), style: TextStyle(color: Colors.white))),
                              ],
                            ),
                          ),
                          ResponsiveRowColumnItem(child: SizedBox(width: 20,),),
                          ResponsiveRowColumnItem(child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                              width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.135, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.315)]).value!,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber,
                                  ),
                                  onPressed: () async {
                                    current = DateTime.now();
                                    endDate = await showDatePicker(
                                      context: context,
                                      initialDate: current!,
                                      firstDate: DateTime(2021),
                                      lastDate: DateTime(DateTime.now().year + 1),
                                      locale: const Locale('en'),
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: Colors.greenAccent,
                                              onPrimary: Colors.white,
                                              surface: Colors.amber,
                                              onSurface: Colors.white,
                                            ),
                                            dialogBackgroundColor:Colors.black87,
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    setState((){});
                                  },
                                  child: Text('End Date', style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              SizedBox(width: 10,),
                              endDate == null ? Container(width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.135, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.315)]).value!, child: Text('Ending Date')) :
                              Container(width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.135, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.315)]).value!, child: Text(endDate.toString(), style: TextStyle(color: Colors.white))),
                            ],
                          ),),
                          ResponsiveRowColumnItem(child: SizedBox(width: 20,),),
                          ResponsiveRowColumnItem(child: Expanded(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber,
                                    ),
                                    onPressed: () async {
                                      if(startDate == null || endDate == null){
                                        sb = ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Please choose dates!'),
                                            action: SnackBarAction(
                                              label: 'okay',
                                              onPressed: () {
                                                // Code to execute.
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        refreshed = false;
                                        showCompletedInstances(startDate.toString().split(' ')[0], endDate.toString().split(' ')[0], context).then((value) => {
                                          completedInstances = value,
                                          refreshed = false,
                                          refresh(),
                                        });
                                      }
                                    },
                                    child: Icon(Icons.search, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                  ZoomDrawer.of(context)!.toggle();
                }
              ),
              backgroundColor: Colors.black87,
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
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Expanded(
                    flex: 15,
                    child: SizedBox(
                      child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            return Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: completedInstances.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1),
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
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
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.of(ctx).pushNamed('/completeInstance', arguments: completedInstances[index].instanceId);
                                            },
                                            title: Container(width: MediaQuery.of(context).size.width * 0.5, child: Text(completedInstances[index].name, style: TextStyle(color: Colors.white), softWrap: true,)),
                                            trailing: Container(width: MediaQuery.of(context).size.width * 0.3, child: Text(completedInstances[index].deadline.toString(), style: TextStyle(color: Colors.white))),
                                          ),
                                        );
                                      }
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                      height: MediaQuery.of(context).size.height * 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.menu), onPressed: (){ZoomDrawer.of(context)!.toggle();}),
            backgroundColor: Colors.black87,
            title: Text("Scheduling"),
          ),
          body: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 1,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.amber.withOpacity(1),
                      ),
                    ),
                    child: TextButton(
                      child: Text('CREATE SCHEDULE +', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.0115, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.0215)]).value!)),
                      onPressed: (){
                        Navigator.of(context).pushNamed('/createchecklistschedule');
                      }
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.amber.withOpacity(1),
                      ),
                    ),
                    child: TextButton(
                        child: Text('DELETE SCHEDULE -', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.0135, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.02)]).value!)),
                        onPressed: (){
                          Navigator.of(context).pushNamed('/deletechecklistschedule');
                        }
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    ];
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.menu_book),
        title: ("Templates"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.square_list),
        title: ("Lists"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.manage_search),
        title: ("Search"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.schedule),
        title: ("Schedule"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
    ];
  }
  Future<String> changeTemplateName(String templateName, String newTemplateName) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/template/changeTemplateName');
    try {
      await HttpClientHelper.put(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'templateName': templateName, 'newTemplateName': newTemplateName, 'location': Login.location}).then((Response? response) => {
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
  Future<String> changeTemplateDepartment(String currentDepartment, String newDepartment, String templateName) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/template/changeTemplateDepartment');
    try {
      await HttpClientHelper.put(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'currentDepartment': currentDepartment, 'newDepartment': newDepartment, 'templateName': templateName, 'location': Login.location}).then((Response? response) => {
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
  Future<String> changeTriggerTargets(int itemId, String targets) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/template/trigger/change/');
    try {
      await HttpClientHelper.put(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'onNetwork': Login.onNetwork.toString(), 'location': Login.location!, 'itemId': itemId.toString(), 'targets': targets}).then((Response? response) => {
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
  Widget createAlertSection(String sectionName, ListTemplate temp) {
    List triggerItems = [];
    List users = [];
    int? itemSelection;
    submit = () {
      if(changeName == true){
        if(templateNameController.text != ''){
          changeTemplateName(temp.name, templateNameController.text).then((value) => {
            templateNameController.clear(),
            if(value == 'successful'){
              refreshed = false,
              refresh(),
            } else if(value == 'exists'){
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Template name already exists!'),
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
                  content: const Text('Could not update template name...'),
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
              content: const Text('Did not update name, field was empty!'),
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
      if(changeDepartment == true){
        String changeDepartment = newDepartment as String;
        changeTemplateDepartment(temp.departmentName, changeDepartment, temp.name).then((value) => {
          if(value == 'successful'){
            newDepartment = -1,
            refreshed = false,
            refresh(),
          } else {
            sb = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Could not switch template\'s department...'),
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
      if(changeTrigger == true){
        if(itemSelection != null){
          String temp = '';
          for(int x = 0; x < users.length; x++){
            Person user = users[x] as Person;
            if(user.selected == true && temp == ''){
              temp += user.userId.toString();
            } else if(user.selected == true && temp != ''){
              temp += ', ';
              temp += user.userId.toString();
            }
          }
          changeTriggerTargets(itemSelection!, temp).then((value) {
            if(value == 'successful'){
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Successfully changed target!'),
                  action: SnackBarAction(
                    label: 'okay',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            } else if(value == 'error'){
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Could not change target...'),
                  action: SnackBarAction(
                    label: 'okay',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            } else {
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Could not change targets, not on the network!'),
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
        }
      }
      Navigator.of(context).pop();
    };
    exit = (){
      Navigator.of(context).pop();
    };
    switch(sectionName){
      case 'name':
        return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Current Template Name: ', style: TextStyle(color: Colors.white, fontSize:
                ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!),),
                Text(
                  '${temp.name}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!,
                  ),
                ),
                Text('What would you like to change it to?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!)),
                Form(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    controller: templateNameController,
                  ),
                ),
              ],
            )
        );
      case 'department':
        return Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3, minWidth: MediaQuery.of(context).size.width * 0.7),
          child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Current Template Department: ', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!)),
                Text(
                  '${temp.departmentName}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.green,
                      fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!
                  ),
                ),
                Text('What would you like to change it to?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!)),
                SizedBox(height: 20,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setState) {
                      return Container(
                        color: Colors.white24,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: departments.length,
                            itemBuilder: (context, index){
                              Department department = departments[index] as Department;
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.075,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: RadioListTile(
                                  value: department.departmentName,
                                  groupValue: newDepartment,
                                  onChanged: (value) {
                                    setState(() {
                                      newDepartment = value;
                                    });
                                  },
                                  title: Text(department.departmentName, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.033)]).value!)),
                                  activeColor: Colors.green,
                                ),
                              );
                            }
                        ),
                      );
                    },
                  ),
                ),
              ],
              ),
        );
      case 'trigger':
        return Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3, minWidth: MediaQuery.of(context).size.width * 0.7),
              child: Column(
                children: [
                  FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasError){
                          return Text('Could not retrieve data');
                        } else if(snapshot.hasData){
                          triggerItems = snapshot.data;
                          return StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) setState) {
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  children: [
                                    Text("Which item would you like to change the trigger for?", style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!)),
                                    Expanded(
                                      child: Container(
                                        color: Colors.white24,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: triggerItems.length,
                                            itemBuilder: (context, index){
                                              AdminTriggerItem item = triggerItems[index] as AdminTriggerItem;
                                              return Container(
                                                height: MediaQuery.of(context).size.height * 0.075,
                                                width: MediaQuery.of(context).size.width * 0.7,
                                                child: RadioListTile<int>(
                                                  activeColor: Colors.green,
                                                  value: item.itemId!,
                                                  groupValue: itemSelection,
                                                  onChanged: (int? value){
                                                      setState((){
                                                        itemSelection = value;
                                                      });
                                                  },
                                                  title: Text(item.itemName!, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!)),
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Text('hello');
                        }
                      } else if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Text('Error');
                      }
                    },
                    future: getTriggerItems(temp.name),
                  ),
                  FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasError){
                          return Text('Could not retrieve data');
                        } else if(snapshot.hasData){
                          users = snapshot.data;
                          return StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) setState) {
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  children: [
                                    Text("Choose who to assign triggers to...", style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!)),
                                    Expanded(
                                      child: Container(
                                        color: Colors.white24,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: users.length,
                                            itemBuilder: (context, index){
                                              Person user = users[index] as Person;
                                              return Container(
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      activeColor: Colors.green,
                                                      onChanged: (bool? value) {
                                                        setState((){
                                                          user.selected = value!;
                                                        });
                                                      },
                                                      value: user.selected,
                                                    ),
                                                    Text(user.first, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.009, valueWhen: [Condition.smallerThan(name: "LAPTOP",  value: MediaQuery.of(context).size.width * 0.0145), Condition.smallerThan(name: TABLET,  value: MediaQuery.of(context).size.width * 0.024)]).value!)),
                                                  ],
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Text('hello');
                        }
                      } else if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Text('Error');
                      }
                    },
                    future: getUsers(),
                  ),
                ],
              ),
        );
      default:
        return Container(width: 0, height: 0,);
    }
  }
  Future<List> getTriggerItems(String? templateName) async {
    String? responseBody;
    Response? responses;

    List temp = [];
    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/items/trigger/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'onNetwork': Login.onNetwork.toString(), 'location': Login.location!.toString(), 'templateName': templateName!.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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


    for(int x = 0; x < jsonList.length; x++){
        temp.add(new AdminTriggerItem(itemId: jsonList[x]['itemId'], itemName: jsonList[x]['itemName']));
    }
    return temp;
  }
  Future<String> createInstance(String? chosenTemplate, DateTime deadline) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/template/createInstance/');
    try {
      await HttpClientHelper.post(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'location': Login.location, 'deadline': deadline.toString(), 'templateName': chosenTemplate, 'onNetwork': Login.onNetwork.toString(), 'userId': Login.userId.toString()}).then((Response? response) => {
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
  Future<String> deleteTemplate(String templateName) async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/template/delete/');
    try {
      await HttpClientHelper.delete(url, timeLimit: Duration(seconds: 5), headers: {'name': templateName, 'location': Login.location!, 'sessionId': Login.sessionId!}).then((Response? response) => {
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
  Future<List> getTemplates() async {
    String? responseBody;
    Response? responses;

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/getTemplate/');

    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
  Future<List<Widget>> create(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List<Widget> _items = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/template/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    try {
      ListTemplate? previousListTemplate = new ListTemplate(name: json[0]['templateName'], departmentName: json[0]['departmentName'], templateItems: {json[0]['itemName'] : '${json[0]['itemId']}' + '_' + '${json[0]['itemType']}'},);
      for(int x = 1; x < json.length; x++){
        if(previousListTemplate!.name == json[x]['templateName']){
          previousListTemplate.templateItems['${json[x]['itemName']}'] = '${json[x]['itemId']}';
        } else {
          _items.add(previousListTemplate);
          previousListTemplate = new ListTemplate(name: json[x]['templateName'], departmentName: json[x]['departmentName'], templateItems: {json[x]['itemName'] : '${json[x]['itemId']}' + '_' + '${json[x]['itemType']}'},);
        }
      }
      _items.add(previousListTemplate!);
    } catch(e) {
      return _items;
    }
    return _items;
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
  Future<List<ListInstance>> showInstances(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List<ListInstance> _instances = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/instances/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'userId': Login.userId.toString(), 'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    for(int x = 0; x < jsonList.length; x++){
      if(jsonList[x]['completed']['data'][0] == 0 || jsonList[x]['signed'] == null){
        _instances.add(new ListInstance(name: jsonList[x]['templateName'], instanceId: jsonList[x]['instanceId'], deadline: DateTime.parse(jsonList[x]['deadline']),));
      }
    }

    return _instances;
  }
  Future<List<ListInstance>> showCompletedInstances(String startTime, String endTime, BuildContext context) async {
    String? responseBody;
    Response? responses;

    List<ListInstance> _instances = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/completedInstances/');
    try {
      await HttpClientHelper.get(url, headers: {'startTime': startTime, 'endTime': endTime, 'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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


    for(int x = 0; x < jsonList.length; x++){
      _instances.add(new ListInstance(name: jsonList[x]['templateName'], instanceId: jsonList[x]['instanceId'], deadline: DateTime.parse(jsonList[x]['deadline']),));
    }

    return _instances;
  }
}


