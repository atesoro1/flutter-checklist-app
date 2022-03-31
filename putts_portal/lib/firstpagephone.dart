import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:putts_portal/admin/adminlist.dart';
import 'package:putts_portal/logout.dart';
import 'package:putts_portal/admin/adminmenu.dart';
import 'package:putts_portal/admin/adminpeople.dart';
import 'package:putts_portal/admin/admindepartment.dart';
import 'admin/adminsettings.dart';
import 'login.dart';
import 'logout.dart';
import 'menuitem.dart';
import 'package:putts_portal/notification.dart';
import 'non-admin/menu.dart';
import 'non-admin/nonadminlist.dart';
import 'non-admin/people.dart';
import 'admin/adminhome.dart';
import 'non-admin/nonadminhome.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  MenuItem currentMenuItem = Login.adminView == 0 ? NonAdminMenuItems.home : AdminMenuItems.home;

  @override
  Widget build(BuildContext context) {

    return ZoomDrawer(
      showShadow: true,
      backgroundColor: Colors.black45,
      mainScreenScale: 0.3,
      slideWidth: 250,
      angle: 0,
      style: DrawerStyle.Style1,
      mainScreen: getScreen(),
      menuScreen: Login.adminView == 1 ? AdminMenu(
          currentAdminMenuItem: currentMenuItem,
          onSelectedItem: (item) {
            setState(() {
              currentMenuItem = item;
            });
          }
      ) : Menu(
          currentAdminMenuItem: currentMenuItem,
          onSelectedItem: (item) {
            setState(() {
              currentMenuItem = item;
            });
          }
      ),
    );
  }


  Widget getScreen(){

    if(Login.adminView == 1){
      switch(currentMenuItem){
        case AdminMenuItems.home:
          return AdminHome();
        case AdminMenuItems.people:
          return AdminPeople();
        case AdminMenuItems.lists:
          return AdminList();
        case AdminMenuItems.departments:
          return AdminDepartment();
        case AdminMenuItems.notifications:
          return AlertNotification();
        case AdminMenuItems.logout:
          return Logout();
        default:
          return Container();
      }
    } else {
      switch(currentMenuItem){
        case NonAdminMenuItems.home:
          return NonAdminHome();
        case NonAdminMenuItems.people:
          return People();
        case NonAdminMenuItems.lists:
          return NonAdminList();
        case NonAdminMenuItems.notifications:
          return AlertNotification();
        case NonAdminMenuItems.logout:
          return Logout();
        default:
          return Container();
      }
    }


  }
}